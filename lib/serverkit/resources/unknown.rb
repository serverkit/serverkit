require "serverkit/errors/unknown_resource_type_error"
require "serverkit/resources/base"

module Serverkit
  module Resources
    class Unknown < Base
      # @return [Array<Serverkit::Errors::UnknownResourceTypeError>]
      def all_errors
        [Errors::UnknownResourceTypeError.new(type)]
      end
    end
  end
end
