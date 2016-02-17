require "active_model"
require "active_model/errors"
require "active_support/core_ext/module/delegation"
require "at_least_one_of_validator"
require "readable_validator"
require "regexp_validator"
require "required_validator"
require "serverkit/errors/attribute_validation_error"
require "type_validator"

module Serverkit
  module Resources
    class Base
      class << self
        attr_writer :abstract_class

        def abstract_class?
          !!@abstract_class
        end

        # @note DSL method to define attribute with its validations
        def attribute(name, options = {})
          default = options.delete(:default)
          define_method(name) do
            @attributes[name.to_s] || default
          end
          validates name, options unless options.empty?
        end
      end

      include ActiveModel::Validations

      attr_accessor :backend

      attr_reader :attributes, :check_result, :recheck_result, :recipe

      attribute :check_script, type: String
      attribute :cwd, type: String
      attribute :id, type: String
      attribute :notify, type: Array
      attribute :recheck_script, type: String
      attribute :type, type: String
      attribute :user, type: String

      delegate(
        :send_file,
        to: :backend,
      )

      self.abstract_class = true

      # @param [Serverkit::Recipe] recipe
      # @param [Hash] attributes
      def initialize(recipe, attributes)
        @attributes = attributes
        @recipe = recipe
      end

      # @note For override
      # @return [Array<Serverkit::Errors::Base>]
      def all_errors
        attribute_validation_errors
      end

      # @return [true, false]
      def check_command(*args)
        run_command(*args).success?
      end

      # @return [true, false]
      def check_command_from_identifier(*args)
        run_command_from_identifier(*args).success?
      end

      # @return [String]
      def get_command_from_identifier(*args)
        backend.command.get(*args)
      end

      # @return [Array<Serverkit::Resource>]
      def handlers
        @handlers ||= Array(notify).map do |id|
          recipe.handlers.find do |handler|
            handler.id == id
          end
        end.compact
      end

      # @note For logging and notifying
      # @return [String]
      def id
        @attributes["id"] || default_id
      end

      # @return [true, false] True if this resource should call any handler
      def notifiable?
        @recheck_result == true && !handlers.nil?
      end

      # @note #check and #apply wrapper
      def run_apply
        unless run_check
          apply
          @recheck_result = !!recheck_with_script
        end
      end

      # @note #check wrapper
      # @return [true, false]
      def run_check
        @check_result = !!check_with_script
      end

      def successful?
        successful_on_check? || successful_on_recheck?
      end

      def successful_on_check?
        @check_result == true
      end

      def successful_on_recheck?
        @recheck_result == true
      end

      # @note recipe resource will override to replace itself with multiple resources
      # @return [Array<Serverkit::Resources::Base>]
      def to_a
        [self]
      end

      private

      # @return [Array<Serverkit::Errors::AttributeValidationError>]
      def attribute_validation_errors
        valid?
        errors.map do |attribute_name, message|
          Serverkit::Errors::AttributeValidationError.new(self, attribute_name, message)
        end
      end

      # @note Prior check_script attribute to resource's #check implementation
      def check_with_script
        if check_script
          check_command(check_script)
        else
          check
        end
      end

      # Create a file on remote side
      # @param [String] content
      # @param [String] path
      def create_remote_file(content: nil, path: nil)
        ::Tempfile.open("") do |file|
          file.write(content)
          file.close
          backend.send_file(file.path, path)
        end
      end

      # Create temp file on remote side with given content
      # @param [String] content
      # @return [String] Path to remote temp file
      def create_remote_temp_file(content)
        make_remote_temp_path.tap do |path|
          update_remote_file_content(content: content, path: path)
        end
      end

      # @note For override
      # @return [String]
      def default_id
        required_values.join(" ")
      end

      # @note GNU mktemp doesn't require -t option, but BSD mktemp does
      # @return [String]
      def make_remote_temp_path
        run_command("mktemp -u 2>/dev/null || mktemp -u -t tmp").stdout.rstrip
      end

      # @note "metadata" means a set of group, mode, and owner
      # @param [String] destination
      # @param [String] source
      def move_remote_file_keeping_destination_metadata(source, destination)
        group = run_command_from_identifier(:get_file_owner_group, destination).stdout.rstrip
        mode = run_command_from_identifier(:get_file_mode, destination).stdout.rstrip
        owner = run_command_from_identifier(:get_file_owner_user, destination).stdout.rstrip
        run_command_from_identifier(:change_file_group, source, group) unless group.empty?
        run_command_from_identifier(:change_file_mode, source, mode) unless mode.empty?
        run_command_from_identifier(:change_file_owner, source, owner) unless owner.empty?
        run_command_from_identifier(:move_file, source, destination)
      end

      # @note For override
      # @return [true, false]
      def recheck
        check
      end

      # @note Prior recheck_script attribute to resource's #recheck implementation
      def recheck_with_script
        if recheck_script
          check_command(recheck_script)
        else
          recheck
        end
      end

      # @return [Array<Symbol>]
      def required_attribute_names
        _validators.select do |key, validators|
          validators.grep(::RequiredValidator).any?
        end.keys
      end

      # @return [Array]
      def required_values
        required_attribute_names.map do |required_attribute_name|
          send(required_attribute_name)
        end
      end

      # @note Wraps backend.run_command for `cwd` and `user` attributes
      # @param [String] command one-line shell script to be executed on remote machine
      # @return [Specinfra::CommandResult]
      def run_command(command)
        case
        when cwd
          command = "cd #{Shellwords.escape(cwd)} && #{command}"
        when user
          command = "cd && #{command}"
        end
        unless user.nil?
          command = "sudo -H -u #{user} -i -- /bin/bash -i -c #{Shellwords.escape(command)}"
        end
        backend.run_command(command)
      end

      # @return [Specinfra::CommandResult]
      def run_command_from_identifier(*args)
        run_command(get_command_from_identifier(*args))
      end

      # Update remote file content on given path with given content
      # @param [String] content
      # @param [String] path
      def update_remote_file_content(content: nil, path: nil)
        group = run_command_from_identifier(:get_file_owner_group, path).stdout.rstrip
        mode = run_command_from_identifier(:get_file_mode, path).stdout.rstrip
        owner = run_command_from_identifier(:get_file_owner_user, path).stdout.rstrip
        create_remote_file(content: content, path: path)
        run_command_from_identifier(:change_file_group, path, group) unless group.empty?
        run_command_from_identifier(:change_file_mode, path, mode) unless mode.empty?
        run_command_from_identifier(:change_file_owner, path, owner) unless owner.empty?
      end
    end
  end
end
