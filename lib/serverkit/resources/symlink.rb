require "serverkit/resources/base"

module Serverkit
  module Resources
    class Symlink < Base
      attribute :destination, required: true, type: String
      attribute :source, required: true, type: String

      # @note Override
      def apply
        run_command_from_identifier(:link_file_to, source, destination, force: true)
      end

      # @note Override
      def check
        check_command_from_identifier(:check_file_is_linked_to, source, destination)
      end

      private

      # @note Override
      def default_id
        source
      end
    end
  end
end
