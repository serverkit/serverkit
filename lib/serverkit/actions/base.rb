require "serverkit/recipe"
require "serverkit/recipe_loader"
require "specinfra"

module Serverkit
  module Actions
    class Base
      # @param [Hash] options
      def initialize(options)
        @options = options
      end

      def call
        raise NotImplementedError
      end

      private

      # @return [Specinfra::Backend::Base]
      def backend
        @backend ||= backend_class.new
      end

      # @return [Class]
      def backend_class
        if recipe.ssh?
          Specinfra::Backend::Ssh
        else
          Specinfra::Backend::Exec
        end
      end

      def load_recipe_data
        RecipeLoader.new(@options[:recipe]).load
      end

      # @return [Serverkit::Recipe]
      def recipe
        @recipe ||= Recipe.new(load_recipe_data)
      end
    end
  end
end
