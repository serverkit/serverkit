require "serverkit/elements/base"

module Serverkit
  module Elements
    class Git < Base
      # @return [true, false]
      def check
        check_command_from_identifier(:check_file_is_directory, git_path)
      end

      private

      # @return [String] Path to .git directory in the cloned repository
      def git_path
        ::File.join(path, ".git")
      end

      # @return [String] Where to locate cloned repository
      def path
        @properties["path"]
      end

      # @return [String] Git repository URL
      def repository
        @properties["repository"]
      end
    end
  end
end
