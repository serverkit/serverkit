require "serverkit/resources/base"

module Serverkit
  module Resources
    class Recipe < Base
      attribute :path, readable: true, required: true, type: String

      # @note Override
      def to_a
        if valid?
          loaded_recipe.resources
        else
          self
        end
      end

      private

      # @return [Serverkit::Recipe] Recipe loaded from given path
      def loaded_recipe
        @loaded_recipe ||= Loaders::RecipeLoader.new(path, variables_path: recipe.variables_path).load
      end
    end
  end
end
