require "serverkit/resources/base"

module Serverkit
  module Resources
    class HomebrewCask < Base
      attribute :name, required: true, type: String

      def apply
        run_command("brew cask install #{name}")
      end

      # @return [true, false]
      def check
        check_command("/usr/local/bin/brew cask list -1 | grep -E '^#{name}$'")
      end
    end
  end
end
