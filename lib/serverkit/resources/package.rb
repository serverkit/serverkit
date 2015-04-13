require "serverkit/resources/base"

module Serverkit
  module Resources
    class Package < Base
      attribute :name, required: true, type: String
      attribute :options, type: String
      attribute :version, type: String

      # @note Override
      def apply
        run_command_from_identifier(:install_package, name, version, options)
      end

      # @note Override
      def check
        check_command_from_identifier(:check_package_is_installed, name, version)
      end
    end
  end
end
