require "serverkit/elements/base"

module Serverkit
  module Elements
    class Git < Base
      DEFAULT_STATUS = "cloned"

      # @return [true, false]
      def check
        case status
        when "updated"
          has_git? && cloned? && updated?
        else
          has_git? && cloned?
        end
      end

      private

      def cloned?
        check_command_from_identifier(:check_file_is_directory, git_path)
      end

      # @return [String] Path to .git directory in the cloned repository
      def git_path
        ::File.join(path, ".git")
      end

      def has_git?
        check_command("which git")
      end

      # @return [String]
      def local_head_revision
        run_command("cd #{path} && git rev-parse HEAD").stdout.rstrip
      end

      # @return [String]
      def origin_head_revision
        run_command("cd #{path} && git ls-remote origin HEAD").stdout.split.first
      end

      # @return [String] Where to locate cloned repository
      def path
        @properties["path"]
      end

      # @return [String] Git repository URL
      def repository
        @properties["repository"]
      end

      # @return [String]
      def status
        @properties["status"] || DEFAULT_STATUS
      end

      def updated?
        local_head_revision == origin_head_revision
      end
    end
  end
end
