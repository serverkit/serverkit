require "serverkit/resources/base"

module Serverkit
  module Resources
    # A class to do nothing for debugging.
    class Nothing < Base
      # @note Override
      def apply
      end

      # @note Override
      def check
        true
      end
    end
  end
end
