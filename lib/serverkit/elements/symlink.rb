require "serverkit/elements/base"

module Serverkit
  module Elements
    class Symlink < Base
      def apply
        run_command_from_identifier(:link_file_to, source, destination)
      end

      # @return [true, false]
      def check
        check_command_from_identifier(:check_file_is_linked_to, source, destination)
      end

      private

      # @return [String]
      def destination
        @properties["destination"]
      end

      # @return [String]
      def source
        @properties["source"]
      end
    end
  end
end
