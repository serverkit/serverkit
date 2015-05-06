require "serverkit/resources/base"

module Serverkit
  module Resources
    class Script < Base
      attribute :path, required: true, type: String

      # @note Override
      def apply
        run_command("sh #{path}")
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
