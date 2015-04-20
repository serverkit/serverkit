require "digest"
require "serverkit/resources/base"

module Serverkit
  module Resources
    class RemoteFile < Base
      attribute :destination, required: true, type: String
      attribute :group, type: String
      attribute :owner, type: String
      attribute :source, readable: true, required: true, type: String

      # @note Override
      def apply
        send_file_from_source_to_destination if file_sendable?
        update_group unless has_correct_group?
        update_owner unless has_correct_owner?
      end

      # @note Override
      def check
        has_file? && has_same_content? && has_correct_group? && has_correct_owner?
      end

      private

      def file_sendable?
        !has_file? || !has_same_content?
      end

      def has_file?
        check_command_from_identifier(:check_file_is_file, destination)
      end

      def has_same_content?
        remote_file_sha256sum == local_file_sha256sum
      end

      def has_correct_group?
        group.nil? || check_command_from_identifier(:check_file_is_grouped, destination, group)
      end

      def has_correct_owner?
        owner.nil? || check_command_from_identifier(:check_file_is_owned_by, destination, owner)
      end

      # @return [String]
      def local_file_sha256sum
        ::Digest::SHA256.hexdigest(::File.read(source))
      end

      # @return [String]
      def remote_file_sha256sum
        run_command_from_identifier(:get_file_sha256sum, destination).stdout.rstrip
      end

      def send_file_from_source_to_destination
        send_file(source, destination)
      end

      def update_group
        run_command_from_identifier(:change_file_group, destination, group)
      end

      def update_owner
        run_command_from_identifier(:change_file_owner, destination, owner)
      end
    end
  end
end
