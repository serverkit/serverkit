require "active_support/core_ext/string/inflections"
require "serverkit/resources/file"
require "serverkit/resources/git"
require "serverkit/resources/homebrew"
require "serverkit/resources/homebrew_cask"
require "serverkit/resources/symlink"
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

    # @return [Array<Serverkit::Resources::Base>]
    # @todo Delegate to resource builder
    def resources
      @resources ||= resource_properties.map do |properties|
        Resources.const_get(properties["type"].camelize, false).new(properties)
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
    def resource_properties
      @raw_recipe["resources"] || []
    end
  end
end
