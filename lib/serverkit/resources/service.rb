require "serverkit/resources/base"

module Serverkit
  module Resources
    class Service < Base
      attribute :name, required: true, type: String

      # @note Override
      def apply
        run_command_from_identifier(:start_service, name)
      end

      # @note Override
      def check
        check_command_from_identifier(:check_service_is_running, name)
      end
    end
  end
end
