require "serverkit/actions/base"
require "yaml"

module Serverkit
  module Actions
    class Inspect < Base
      def call
        if recipe.valid?
          puts JSON.pretty_generate(recipe.to_hash)
        else
          abort_with_errors
        end
      end
    end
  end
end
