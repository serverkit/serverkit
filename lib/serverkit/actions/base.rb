require "serverkit/errors/missing_recipe_path_argument_error"
require "serverkit/loaders/recipe_loader"
require "serverkit/recipe"
require "slop"
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
        @options ||= Slop.parse!(@argv, help: true) do
          banner "Usage: serverkit ACTION [options]"
          on "--variables=", "Path to variables file for ERB recipe"
        end
      end

      # @return [Serverkit::Recipe]
      def recipe
        @recipe ||= Loaders::RecipeLoader.new(recipe_path, variables_path: options[:variables]).load
      end

      # @return [String, nil]
      def recipe_path
        @argv[1] or raise Errors::MissingRecipePathArgumentError
      end
    end
  end
end
