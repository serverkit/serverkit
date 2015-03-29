module Serverkit
  module Elements
    class Base
      # @note @backend will be set before calling #check method
      attr_accessor :backend

      # @param [Hash] properties
      def initialize(properties)
        @properties = properties
      end

      # @note Override this
      # @param [Specinfra::Backend::Base] backend
      # @return [true, false]
      def check(backend)
        raise NotImplementedError
      end

      # @return [String]
      def name
        @properties["name"]
      end

      private

      # @param [String] command
      # @return [true, false]
      def check_command(*args)
        run_command(*args).success?
      end

      # @param [Symbol] command_identifier
      # @return [true, false]
      def check_command_from_identifier(*args)
        run_command_from_identifier(*args).success?
      end

      # @param [String] command
      # @return [Specinfra::CommandResult]
      def run_command(*args)
        backend.run_command(*args)
      end

      # @param [Symbol] command_identifier
      # @return [Specinfra::CommandResult]
      def run_command_from_identifier(*args)
        run_command(backend.command.get(*args))
      end
    end
  end
end
