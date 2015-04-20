require "digest"
require "serverkit/resources/base"
require "tempfile"

module Serverkit
  module Resources
    # Abstract class for file and directory
    class Entry < Base
      attribute :group, type: String
      attribute :mode, type: [Integer, String]
      attribute :owner, type: String

      self.abstract_class = true

      # @note Override
      def apply
        update_entry unless has_correct_entry?
        update_group unless has_correct_group?
        update_mode unless has_correct_mode?
        update_owner unless has_correct_owner?
      end

      # @note Override
      def check
        has_correct_entry? && has_correct_group? && has_correct_mode? && has_correct_owner?
      end

      private

      # @note Override me
      # @return [String] Path to the entry on remote side
      def destination
        raise NotImplementedError
      end

      def has_correct_content?
        content.nil? || remote_file_sha256sum == local_content_sha256sum
      end

      # @note Override me
      def has_correct_entry?
        raise NotImplementedError
      end

      def has_correct_group?
        group.nil? || check_command_from_identifier(:check_file_is_grouped, destination, group)
      end

      def has_correct_mode?
        mode.nil? || check_command_from_identifier(:check_file_has_mode, destination, mode_in_octal_notation)
      end

      def has_correct_owner?
        owner.nil? || check_command_from_identifier(:check_file_is_owned_by, destination, owner)
      end

      def has_remote_file?
        check_command_from_identifier(:check_file_is_file, destination)
      end

      # @return [String]
      def local_content_sha256sum
        ::Digest::SHA256.hexdigest(content)
      end

      # @return [String]
      # @example "755" # for 0755
      def mode_in_octal_notation
        if mode.is_a?(Integer)
          mode.to_s(8)
        else
          mode
        end
      end

      # @return [String]
      def remote_file_sha256sum
        run_command_from_identifier(:get_file_sha256sum, destination).stdout.rstrip
      end

      def send_content_to_destination
        ::Tempfile.open("") do |file|
          file.write(content || "")
          file.close
          backend.send_file(file.path, destination)
        end
      end

      # @note Override me
      def update_entry
        raise NotImplementedError
      end

      def update_group
        run_command_from_identifier(:change_file_group, destination, group)
      end

      def update_mode
        run_command_from_identifier(:change_file_mode, destination, mode_in_octal_notation)
      end

      def update_owner
        run_command_from_identifier(:change_file_owner, destination, owner)
      end
    end
  end
end
