require "serverkit/resources/base"

module Serverkit
  module Resources
    class HomebrewCask < Base
      attribute :package, presence: true

      def apply
        run_command("brew cask install #{package}")
      end

      # @return [true, false]
      def check
        check_command("/usr/local/bin/brew cask list -1 | grep -E '^#{package}$'")
      end
    end
  end
end
