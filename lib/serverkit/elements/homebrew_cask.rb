require "serverkit/elements/base"

module Serverkit
  module Elements
    class HomebrewCask < Base
      # @param [Specinfra::Backend::Base] backend
      # @return [true, false]
      def check(backend)
        backend.run_command("/usr/local/bin/brew cask list -1 | grep -E '^#{package}$'").success?
      end

      private

      # @return [String]
      def package
        @properties["package"]
      end
    end
  end
end
