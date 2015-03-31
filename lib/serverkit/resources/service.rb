require "serverkit/resources/base"
require "required_validator"

module Serverkit
  module Resources
    class Service < Base
      attribute :name, required: true

      def apply
        run_command_from_identifier(:start, name)
      end

      def check
        check_command_from_identifier(:check_service_is_running, name)
      end
    end
  end
end
