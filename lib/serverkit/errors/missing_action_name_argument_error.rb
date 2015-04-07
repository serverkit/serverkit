require "serverkit/errors/base"

module Serverkit
  module Errors
    class MissingActionNameArgumentError < Base
      # @return [String]
      def to_s
        "Missing action name argument"
      end
    end
  end
end
