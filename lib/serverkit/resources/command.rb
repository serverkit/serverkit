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

      private

      # @note Override
      def recheck
        if check_script
          check_command(check_script)
        else
          true
        end
      end
    end
  end
end
