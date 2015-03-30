module Serverkit
  module Resources
    class Base
      # @note Provide DSL methods to define validatable attributes
      class << self
      end

      attr_accessor :backend

      # @param [Hash] attributes
      def initialize(attributes)
        @attributes = attributes
      end

      # @todo
      # @return [Array<Serverkit::Errors::Base>]
      def errors
        []
      end

      # @return [String]
      def name
        @attributes["name"]
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
