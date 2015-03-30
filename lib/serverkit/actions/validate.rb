require "serverkit/actions/base"

module Serverkit
  module Actions
    class Validate < Base
      def call
        if recipe.valid?
          puts "Success"
        else
          abort recipe.errors.map { |error| "Error: #{error}" }.join("\n")
        end
      end
    end
  end
end
