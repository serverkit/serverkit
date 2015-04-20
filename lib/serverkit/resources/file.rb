require "serverkit/resources/entry"

module Serverkit
  module Resources
    class File < Entry
      attribute :content, type: String
      attribute :path, required: true, type: String

      private

      # @note Override
      def destination
        path
      end

      # @note Override
      def has_correct_entry?
        has_remote_file? && has_correct_content?
      end

      # @note Override
      def update_entry
        send_content_to_destination
      end
    end
  end
end
