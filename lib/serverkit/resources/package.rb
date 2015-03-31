require "serverkit/resources/base"

module Serverkit
  module Resources
    class Package < Base
      attribute :name, required: true

      def apply
        run_command_from_identifier(:install, name)
      end

      # @return [true, false]
      def check
        check_command_from_identifier(:check_package_is_installed, name)
      end
    end
  end
end
