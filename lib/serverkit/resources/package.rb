require "serverkit/resources/base"

module Serverkit
  module Resources
    class Package < Base
      attribute :name, required: true, type: String

      # @note Override
      def apply
        run_command_from_identifier(:install_package, name)
      end

      # @note Override
      def check
        check_command_from_identifier(:check_package_is_installed, name)
      end

      private

      # @note Override
      def default_id
        name
      end
    end
  end
end
