require "active_support/core_ext/string/inflections"
require "serverkit/errors/invalid_recipe_type"
require "serverkit/errors/invalid_resources_type"
require "serverkit/resources/file"
require "serverkit/resources/git"
require "serverkit/resources/homebrew"
require "serverkit/resources/homebrew_cask"
require "serverkit/resources/symlink"
require "yaml"

module Serverkit
  class Recipe
    attr_reader :recipe_data

    # @param [Hash] recipe_data
    def initialize(recipe_data)
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

    # @return [Array<Serverkit::Resources::Base>]
    # @todo Delegate to resource builder
    def resources
      @resources ||= resources_property.map do |attributes|
        Resources.const_get(attributes["type"].camelize, false).new(attributes)
      end
    end

    # @return [true, false] Flag to use SSH (default: true)
    def ssh?
      @recipe_data["ssh"] != false
    end

    def valid?
      errors.empty?
    end

    private

    # @return [Array<Serverkit::Errors::Base>]
    def errors_for_invalid_typed_recipe_data
      [Errors::InvalidRecipeType.new(@recipe_data.class)]
    end

    # @return [Array<Serverkit::Errors::Base>]
    def errors_for_invalid_typed_resources_property
      [Errors::InvalidResourcesType.new(resources_property.class)]
    end

    # @return [Array<Serverkit::Errors::Base>]
    def errors_in_resources
      resources.flat_map do |resource|
        resource.validate
        resource.errors.to_a
      end
    end

    def has_valid_typed_resources_property?
      resources_property.is_a?(Array)
    end

    def has_valid_typed_recipe_data?
      @recipe_data.is_a?(Hash)
    end

    # @return [Array<String>]
    def resources_property
      @recipe_data["resources"] || []
    end
  end
end
