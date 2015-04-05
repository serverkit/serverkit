require "serverkit/loaders/recipe_loader"
require "serverkit/recipe"
require "specinfra"

module Serverkit
  module Actions
    class Base
      # @param [Slop] options
      def initialize(options)
        @options = options
      end

      private

      def abort_with_errors
        abort recipe.errors.map { |error| "Error: #{error}" }.join("\n")
      end

      # @return [Specinfra::Backend::Base]
      def backend
        @backend ||= Specinfra::Backend::Exec.new
      end

      # @return [Serverkit::Recipe]
      def recipe
        @recipe ||= Loaders::RecipeLoader.new(@options[:recipe], variables_path: @options[:variables]).load
      end
    end
  end
end
