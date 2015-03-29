require "active_support/core_ext/string/inflections"
require "serverkit/elements/file"
require "serverkit/elements/homebrew"
require "serverkit/elements/homebrew_cask"
require "serverkit/elements/symlink"
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
      @elements ||= element_properties.map do |properties|
        Elements.const_get(properties["type"].camelize, false).new(properties)
      end
    end

    # @return [Array<String>]
    def hosts
      @raw_recipe["hosts"]
    end

    # @return [true, false] Flag to use SSH (default: true)
    def ssh?
      @raw_recipe["ssh"] != false
    end

    private

    # @return [Array<String>]
    def element_properties
      @raw_recipe["elements"] || []
    end
  end
end
