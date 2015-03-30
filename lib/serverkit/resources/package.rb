require "serverkit/resources/base"

module Serverkit
  module Resources
    class Package < Base
      attribute :package, required: true

      def apply
        run_command_from_identifier(:install, package)
      end

      # @return [true, false]
      def check
        check_command_from_identifier(:check_package_is_installed, package)
      end
    end
  end
end
