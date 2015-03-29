require "serverkit/recipe"

module Serverkit
  module Actions
    class Check
      # @param [Hash] options
      def initialize(options)
        @options = options
      end

      # @todo
      def call
        validate_recipe!
        recipe.elements.each do |element|
          p element
        end
      end

      private

      # @return [Serverkit::Recipe]
      def recipe
        @recipe ||= Recipe.load_from_path(@options[:recipe])
      end

      # @todo Define proper error class
      def validate_recipe!
        raise unless recipe.valid?
      end
    end
  end
end
