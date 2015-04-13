require "active_model"
require "active_support/core_ext/module/delegation"
require "readable_validator"
require "required_validator"
require "serverkit/errors/attribute_validation_error"
require "type_validator"

module Serverkit
  module Resources
    class Base
      class << self
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

      attr_reader :attributes, :recipe

      attribute :id, type: String
      attribute :notify, type: Array
      attribute :type, type: String

      delegate(
        :check_command,
        :check_command_from_identifier,
        :get_command_from_identifier,
        :run_command,
        :run_command_from_identifier,
        :send_file,
        to: :backend,
      )

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

      # @return [String]
      def inspect_apply_result
        case @recheck_result
        when nil
          "[SKIP] #{result_inspection_suffix}"
        when false
          "[FAIL] #{result_inspection_suffix}"
        else
          "[DONE] #{result_inspection_suffix}"
        end
      end

      # @return [String]
      def inspect_check_result
        if @check_result
          "[ OK ] #{result_inspection_suffix}"
        else
          "[ NG ] #{result_inspection_suffix}"
        end
      end

      # @return [true, false] True if this resource should call any handler
      def notifiable?
        @recheck_result == true && !handlers.nil?
      end

      # @note #check and #apply wrapper
      def run_apply
        unless run_check
          apply
          @recheck_result = !!recheck
        end
      end

      # @note #check wrapper
      # @return [true, false]
      def run_check
        @check_result = !!check
      end

      # @return [true, false]
      def successful?
        @check_result == true || @recheck_result == true
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

      # @note For override
      # @return [String]
      def default_id
        required_values.join(" ")
      end

      # @note For override
      # @return [true, false]
      def recheck
        check
      end

      # @return [String]
      def result_inspection_suffix
        "#{type} #{id} on #{backend.host}"
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
    end
  end
end
