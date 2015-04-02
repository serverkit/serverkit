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
        @backend ||= Specinfra::Backend::Exec.new
      end

      # @return [Serverkit::Recipe]
      def recipe
        @recipe ||= RecipeLoader.new(@options[:recipe]).load
      end
    end
  end
end
