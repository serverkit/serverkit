require "serverkit/loaders/recipe_loader"
require "serverkit/recipe"
require "specinfra"

module Serverkit
  module Actions
    class Base
      # @param [Array] argv Command-line arguments given to serverkit executable
      def initialize(argv)
        @argv = argv
      end

      private

      def abort_with_errors
        abort recipe.errors.map { |error| "Error: #{error}" }.join("\n")
      end

      # @return [Specinfra::Backend::Base]
      def backend
        @backend ||= Specinfra::Backend::Exec.new
      end

      # @return [Slop] Command-line options
      def options
        @options ||= Slop.parse!(@argv) do
          banner "Usage: serverkit ACTION [options]"
          on "-r", "--recipe=", "Path to recipe file", required: true
          on "--variables=", "Path to variables file for ERB recipe"
        end
      end

      # @return [Serverkit::Recipe]
      def recipe
        @recipe ||= Loaders::RecipeLoader.new(options[:recipe], variables_path: options[:variables]).load
      end
    end
  end
end
