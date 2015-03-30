require "serverkit/errors/base"

module Serverkit
  module Errors
    class InvalidRecipeType < Base
      # @param [Class] type
      def initialize(type)
        @type = type
      end

      def to_s
        "Recipe data must be a Hash, not #{@type}"
      end
    end
  end
end
