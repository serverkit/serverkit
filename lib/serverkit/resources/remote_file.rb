require "serverkit/resources/entry"

module Serverkit
  module Resources
    class RemoteFile < Entry
      attribute :destination, required: true, type: String
      attribute :source, readable: true, required: true, type: String

      private

      def content
        @content ||= ::File.read(source)
      end

      # @note Override
      def has_correct_entry?
        has_remote_file? && has_correct_content?
      end

      # @note Override
      def update_entry
        send_file(source, destination)
      end
    end
  end
end
