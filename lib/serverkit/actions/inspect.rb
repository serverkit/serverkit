require "serverkit/actions/base"
require "yaml"

module Serverkit
  module Actions
    class Inspect < Base
      def run
        puts JSON.pretty_generate(recipe.to_hash)
      end
    end
  end
end
