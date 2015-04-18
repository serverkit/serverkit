require "active_support/core_ext/module/delegation"
require "serverkit/logger"

module Serverkit
  module Backends
    class BaseBackend
      delegate(
        :send_file,
        to: :specinfra_backend,
      )

      def initialize(log_level: nil)
        @log_level = log_level
      end

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

      # @return [Serverkit::Logger]
      def logger
        @logger ||= Serverkit::Logger.new($stdout).tap do |_logger|
          _logger.level = @log_level
        end
      end

      # @return [Specinfra::CommandResult]
      def run_command(*args)
        logger.debug("Running #{args.first.inspect} on #{host}")
        specinfra_backend.run_command(*args).tap do |result|
          logger.debug(result.stdout) unless result.stdout.empty?
          logger.debug(result.stderr) unless result.stderr.empty?
          logger.debug("Finished with #{result.exit_status} on #{host}")
        end
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
