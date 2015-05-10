require "active_support/core_ext/module/delegation"
require "serverkit/logger"

module Serverkit
  module Backends
    class BaseBackend
      delegate(
        :command,
        :send_file,
        to: :specinfra_backend,
      )

      def initialize(log_level: nil)
        @log_level = log_level
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

      # @param [String] command one-line shell script to be executed on remote machine
      # @return [Specinfra::CommandResult]
      def run_command(command)
        logger.debug("Running #{command} on #{host}")
        specinfra_backend.run_command(command).tap do |result|
          logger.debug(result.stdout) unless result.stdout.empty?
          logger.debug(result.stderr) unless result.stderr.empty?
          logger.debug("Finished with #{result.exit_status} on #{host}")
        end
      end

      def send_file(from, to)
        logger.debug("Sending file #{from} to #{to}")
        specinfra_backend.send_file(from, to)
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
