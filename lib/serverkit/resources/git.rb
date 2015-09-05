require "serverkit/resources/base"

module Serverkit
  module Resources
    class Git < Base
      DEFAULT_STATE = "cloned"

      attribute :path, required: true, type: String
      attribute :repository, required: true, type: String
      attribute :state, default: DEFAULT_STATE, inclusion: %w[cloned updated], type: String
      attribute :branch, type: String

      # @note Override
      def apply
        _clone if clonable?
        checkout if checkoutable?
        update if updatable?
      end

      # @note Override
      def check
        has_git? && cloned? && !checkoutable? && !updatable?
      end

      private

      def clonable?
        !cloned?
      end

      # @note #clone is reserved ;(
      def _clone
        run_command("git clone #{repository} #{path}")
      end

      def cloned?
        check_command_from_identifier(:check_file_is_directory, git_path)
      end

      def checkoutable?
        branch && !checkouted?
      end

      def checkout
        run_command("git -C #{path} checkout #{branch}")
      end

      def checkouted?
        check_command("cd #{path} && test `git rev-parse HEAD` = `git rev-parse #{branch}`")
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

      def updatable?
        state == "updated" && !updated?
      end

      def update
        run_command("cd #{path} && git fetch origin && git reset --hard FETCH_HEAD")
      end

      def updated?
        local_head_revision == origin_head_revision
      end
    end
  end
end
