require "serverkit/errors/missing_resource_type_error"
require "serverkit/resources/base"

module Serverkit
  module Resources
    class Missing < Base
      # @return [Array<Serverkit::Errors::MissingResourceTypeError>]
      def all_errors
        [Errors::MissingResourceTypeError.new]
      end
    end
  end
end
