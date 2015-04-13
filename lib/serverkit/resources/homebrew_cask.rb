require "serverkit/resources/base"

module Serverkit
  module Resources
    class HomebrewCask < Base
      attribute :name, required: true, type: String

      # @note Override
      def apply
        run_command("brew cask install #{name}")
      end

      # @note Override
      def check
        check_command("/usr/local/bin/brew cask list -1 | grep -E '^#{name}$'")
      end
    end
  end
end
