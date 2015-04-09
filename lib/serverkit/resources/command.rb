require "serverkit/resources/base"

module Serverkit
  module Resources
    class Command < Base
      attribute :script, required: true, type: String

      # @note Override
      def apply
        run_command(script)
      end

      # @note Override
      def check
        false
      end

      # @note Override
      def recheck
        true
      end
    end
  end
end
