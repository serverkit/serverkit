require "serverkit/elements/base"

module Serverkit
  module Elements
    class Symlink < Base
      # @param [Specinfra::Backend::Base] backend
      # @return [true, false]
      def check(backend)
        command = backend.command.get(:check_file_is_linked_to, source, destination)
        backend.run_command(command).success?
      end

      private

      # @return [String]
      def destination
        @properties["destination"]
      end

      # @return [String]
      def source
        @properties["source"]
      end
    end
  end
end
