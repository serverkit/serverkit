require "active_support/core_ext/string/inflections"
require "serverkit/elements/file"
require "serverkit/elements/homebrew"
require "serverkit/elements/homebrew_cask"
require "yaml"

module Serverkit
  class Recipe
    class << self
      # @param [String] path
      def load_from_path(path)
        raw_recipe = YAML.load_file(path)
        new(raw_recipe)
      end
    end

    # @param [Hash] raw_recipe
    def initialize(raw_recipe)
      @raw_recipe = raw_recipe
    end

    # @return [Array<Serverkit::Elements::Base>]
    # @todo Delegate to element builder
    def elements
      @elements ||= element_definitions.map do |element_definition|
        Elements.const_get(element_definition["type"].camelize, false).new({})
      end
    end

    # @return [true, false] False if any error is found from recipe definition (e.g. unknown type)
    def valid?
      elements.all?(&:valid?)
    end

    private

    # @return [Array<String>]
    def element_definitions
      @raw_recipe["elements"] || []
    end
  end
end
