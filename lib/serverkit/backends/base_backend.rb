require "active_support/core_ext/module/delegation"

module Serverkit
  module Backends
    class BaseBackend
      delegate(
        :run_command,
        :send_file,
        to: :specinfra_backend,
      )

      # @return [true, false]
      def check_command(*args)
        run_command(*args).success?
      end

      # @return [true, false]
      def check_command_from_identifier(*args)
        run_command_from_identifier(*args).success?
      end

      # @return [String]
      def get_command_from_identifier(*args)
        specinfra_backend.command.get(*args)
      end

      # @note Override me
      # @return [String]
      # @example "localhost"
      def host
        raise NotImplementedError
      end

      # @return [Specinfra::CommandResult]
      def run_command(*args)
        specinfra_backend.run_command(*args)
      end

      # @return [Specinfra::CommandResult]
      def run_command_from_identifier(*args)
        run_command(get_command_from_identifier(*args))
      end

      private

      # @note Override me
      # @return [Specinfra::Backend::Base]
      def specinfra_backend
        raise NotImplementedError
      end
    end
  end
end
