require "serverkit/resources/entry"

module Serverkit
  module Resources
    class Directory < Entry
      attribute :path, required: true, type: String

      private

      # @note Override
      def destination
        path
      end

      # @note Override
      def has_correct_entry?
        check_command_from_identifier(:check_file_is_directory, destination)
      end

      # @note Override
      def update_entry
        run_command_from_identifier(:create_file_as_directory, destination)
      end
    end
  end
end
