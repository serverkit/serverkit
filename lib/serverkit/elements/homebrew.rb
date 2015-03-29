require "serverkit/elements/base"

module Serverkit
  module Elements
    class Homebrew < Base
      # @param [Specinfra::Backend::Base] backend
      # @return [true, false]
      def check(backend)
        command = backend.command.get(:check_package_is_installed_by_homebrew, package)
        backend.run_command(command).success?
      end

      private

      # @return [String]
      def package
        @properties["package"]
      end
    end
  end
end
