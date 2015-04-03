require "active_model"
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

      attribute :id, required: true, type: String

      # @param [Hash] attributes
      def initialize(attributes)
        @attributes = attributes
      end

      # @note For override use
      # @return [Array<Serverkit::Errors::Base>]
      def all_errors
        attribute_validation_errors
      end

      # @return [String]
      def type
        @attributes["type"]
      end

      private

      # @return [Array<Serverkit::Errors::AttributeValidationError>]
      def attribute_validation_errors
        validate
        errors.map do |attribute_name, message|
          Serverkit::Errors::AttributeValidationError.new(self, attribute_name, message)
        end
      end

      # @return [true, false]
      def check_command(*args)
        run_command(*args).success?
      end

      # @return [true, false]
      def check_command_from_identifier(*args)
        run_command_from_identifier(*args).success?
      end

      # @return [Specinfra::CommandResult]
      def run_command(*args)
        backend.run_command(*args)
      end

      # @return [Specinfra::CommandResult]
      def run_command_from_identifier(*args)
        run_command(backend.command.get(*args))
      end
    end
  end
end
