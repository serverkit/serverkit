require "serverkit/actions/base"

module Serverkit
  module Actions
    class Inspect < Base
      def run
        puts JSON.pretty_generate(recipe.to_hash)
      end
    end
  end
end
