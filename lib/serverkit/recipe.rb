require "active_support/core_ext/hash/deep_merge"
require "serverkit/errors/invalid_recipe_type_error"
require "serverkit/errors/invalid_resources_type_error"
require "serverkit/resource_builder"

module Serverkit
  class Recipe
    attr_reader :recipe_data

    # @param [Hash] recipe_data
    def initialize(recipe_data = {})
      @recipe_data = recipe_data
    end

    # @return [Array<Serverkit::Errors::Base>]
    def errors
      @errors ||= begin
        case
        when !has_valid_typed_recipe_data?
          errors_for_invalid_typed_recipe_data
        when !has_valid_typed_resources_property?
          errors_for_invalid_typed_resources_property
        else
          errors_in_resources
        end
      end
    end

    # @return [Array<String>]
    def hosts
      @recipe_data["hosts"]
    end

    # @param [Serverkit::Recipe] recipe
    # @return [Serverkit::Recipe]
    def merge(recipe)
      self.class.new(
        recipe_data.deep_merge(recipe.recipe_data) do |key, a, b|
          if a.is_a?(Array)
            a | b
          else
            b
          end
        end
      )
    end

    # @return [Array<Serverkit::Resources::Base>]
    def resources
      @resources ||= resources_property.map do |attributes|
        ResourceBuilder.new(attributes).build
      end
    end

    def valid?
      errors.empty?
    end

    private

    # @return [Array<Serverkit::Errors::Base>]
    def errors_for_invalid_typed_recipe_data
      [Errors::InvalidRecipeTypeError.new(@recipe_data.class)]
    end

    # @return [Array<Serverkit::Errors::Base>]
    def errors_for_invalid_typed_resources_property
      [Errors::InvalidResourcesTypeError.new(resources_property.class)]
    end

    # @return [Array<Serverkit::Errors::AttributeValidationError>]
    def errors_in_resources
      resources.flat_map(&:attribute_validation_errors)
    end

    def has_valid_typed_resources_property?
      resources_property.is_a?(Array)
    end

    def has_valid_typed_recipe_data?
      @recipe_data.is_a?(Hash)
    end

    # @return [Array<String>, nil]
    def resources_property
      @recipe_data["resources"]
    end
  end
end
