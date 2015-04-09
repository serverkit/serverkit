require "serverkit/errors/base"

module Serverkit
  module Errors
    class MissingResourceTypeError < Base
      # @return [String]
      def to_s
        "Missing resource type"
      end
    end
  end
end
