require "serverkit/loaders/recipe_loader"
require "serverkit/recipe"
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
        @backend ||= Specinfra::Backend::Exec.new
      end

      # @return [Serverkit::Recipe]
      def recipe
        @recipe ||= Loaders::RecipeLoader.new(@options[:recipe], variables_path: @options[:variables]).load
      end
    end
  end
end
