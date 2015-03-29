require "serverkit/elements/base"

module Serverkit
  module Elements
    class File < Base
      # @return [true, false]
      def check
        check_command_from_identifier(:check_file_is_file, path)
      end

      private

      # @return [String]
      def path
        @properties["destination"]
      end
    end
  end
end
