require "serverkit/resources/base"

module Serverkit
  module Resources
    class Command < Base
      attribute :check_script, type: String
      attribute :script, required: true, type: String
      attribute :recheck_script, type: String

      # @note Override
      def apply
        run_command(script)
      end

      # @note Override
      def check
        if check_script
          check_command(check_script)
        else
          false
        end
      end

      private

      def default_id
        script
      end

      # @note Override
      def recheck
        case
        when recheck_script
          check_command(recheck_script)
        when check_script
          check_command(check_script)
        else
          true
        end
      end
    end
  end
end
