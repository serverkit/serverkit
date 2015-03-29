require "digest"
require "serverkit/elements/base"

module Serverkit
  module Elements
    class File < Base
      def apply
        run_command_from_identifier(source, destination)
      end

      # @return [true, false]
      def check
        has_file? && has_same_content?
      end

      private

      # @return [String]
      def destination
        @properties["destination"]
      end

      def has_file?
        check_command_from_identifier(:check_file_is_file, destination)
      end

      def has_same_content?
        remote_file_sha256sum == local_file_sha256sum
      end

      # @todo Rescue Errno::ENOENT from File.read
      # @return [String]
      def local_file_sha256sum
        ::Digest::SHA256.hexdigest(::File.read(source))
      end

      # @return [String]
      def remote_file_sha256sum
        run_command_from_identifier(:get_file_sha256sum, destination).stdout.rstrip
      end

      # @return [String]
      def source
        @properties["source"]
      end
    end
  end
end
