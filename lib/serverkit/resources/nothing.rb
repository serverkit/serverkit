require "serverkit/resources/base"

module Serverkit
  module Resources
    # A class to do nothing for debugging.
    class Nothing < Base
      # @note Override
      def apply
      end

      # @note Override for #apply to be always called
      def check
        false
      end

      private

      # @note Override to always pass rechecking
      def recheck
        true
      end
    end
  end
end
