require "serverkit/elements/base"

module Serverkit
  module Elements
    class File < Base
      # @param [Specinfra::Backend::Base] backend
      # @return [true, false]
      def check(backend)
        command = backend.command.get(:check_file_is_file, path)
        backend.run_command(command).success?
      end

      private

      # @return [String]
      def path
        @properties["destination"]
      end
    end
  end
end
