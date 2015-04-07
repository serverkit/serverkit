require "serverkit/errors/base"

module Serverkit
  module Errors
    class MissingRecipePathArgumentError < Base
      # @return [String]
      def to_s
        "Missing recipe path argument"
      end
    end
  end
end
