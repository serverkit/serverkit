require "serverkit/resources/base"

module Serverkit
  module Resources
    class Symlink < Base
      attribute :destination, required: true
      attribute :source, required: true

      def apply
        run_command_from_identifier(:link_file_to, source, destination)
      end

      # @return [true, false]
      def check
        check_command_from_identifier(:check_file_is_linked_to, source, destination)
      end
    end
  end
end
