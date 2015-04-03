require "serverkit/errors/base"

module Serverkit
  module Errors
    class InvalidResourcesTypeError < Base
      # @param [Class] type
      def initialize(type)
        @type = type
      end

      def to_s
        "resources property must be an Array, not #{@type}"
      end
    end
  end
end
