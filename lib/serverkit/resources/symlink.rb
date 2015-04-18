require "serverkit/resources/base"

module Serverkit
  module Resources
    class Symlink < Base
      attribute :destination, required: true, type: String
      attribute :source, required: true, type: String

      # @note Specinfra's #link_to command does not support -f option for now
      # @note Override
      def apply
        run_command("ln -fs #{destination} #{source}")
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
