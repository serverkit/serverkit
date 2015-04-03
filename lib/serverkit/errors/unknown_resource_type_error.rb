require "serverkit/errors/base"

module Serverkit
  module Errors
    class UnknownResourceTypeError < Base
      # @param [String] type
      def initialize(type)
        @type = type
      end

      # @return [String]
      def to_s
        "Unknown `#{@type}` resource type"
      end
    end
  end
end
