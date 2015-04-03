require "serverkit/errors/base"

module Serverkit
  module Errors
    class AttributeValidationError < Base
      # @param [Serverkit::Resources::Base] resource
      # @param [String] validation_error_message
      def initialize(resource, attribute_name, validation_error_message)
        @attribute_name = attribute_name
        @resource = resource
        @validation_error_message = validation_error_message
      end

      # @return [String]
      def to_s
        "#{@attribute_name} attribute #{@validation_error_message} in #{@resource.type} resource"
      end
    end
  end
end
