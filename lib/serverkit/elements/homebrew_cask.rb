require "serverkit/elements/base"

module Serverkit
  module Elements
    class HomebrewCask < Base
      def apply
        run_command("brew cask install #{package}")
      end

      # @return [true, false]
      def check
        check_command("/usr/local/bin/brew cask list -1 | grep -E '^#{package}$'")
      end

      private

      # @return [String]
      def package
        @properties["package"]
      end
    end
  end
end
