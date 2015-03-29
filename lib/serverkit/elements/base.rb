module Serverkit
  module Elements
    class Base
      # @note @backend will be set before calling #check method
      attr_accessor :backend

      # @param [Hash] properties
      def initialize(properties)
        @properties = properties
      end

      # @return [String]
      def name
        @properties["name"]
      end

      private

      # @return [true, false]
      def check_command(*args)
        run_command(*args).success?
      end

      # @return [true, false]
      def check_command_from_identifier(*args)
        run_command_from_identifier(*args).success?
      end

      # @return [Specinfra::CommandResult]
      def run_command(*args)
        backend.run_command(*args)
      end

      # @return [Specinfra::CommandResult]
      def run_command_from_identifier(*args)
        run_command(backend.command.get(*args))
      end
    end
  end
end
