require "json"
require "pathname"

module Serverkit
  class RecipeLoader
    YAML_EXTNAMES = [".yaml", ".yml"]

    # @param [String] recipe_path
    def initialize(recipe_path)
      @recipe_path = recipe_path
    end

    # @todo Care Error::ENOENT error
    # @return [Serverkit::Recipe]
    def load
      if has_directory_recipe_path?
        load_recipe_from_directory
      else
        Recipe.new(load_recipe_data)
      end
    end

    private

    # @return [String] This executable must print reicpe in JSON format into standard output
    def execute
      `#{recipe_path}`
    end

    # @return [String]
    def extname
      @extname ||= recipe_pathname.extname
    end

    def has_directory_recipe_path?
      recipe_pathname.directory?
    end

    def has_executable_recipe_path?
      recipe_pathname.executable?
    end

    def has_yaml_recipe_path?
      YAML_EXTNAMES.include?(extname)
    end

    def load_recipe_data
      case
      when has_executable_recipe_path?
        load_recipe_data_from_executable
      when has_yaml_recipe_path?
        load_recipe_data_from_yaml
      else
        load_recipe_data_from_json
      end
    end

    def load_recipe_from_directory
      load_recipes_from_directory.inject(Recipe.new, :merge)
    end

    def load_recipes_from_directory
      Dir.glob(recipe_pathname.join("*")).sort.flat_map do |path|
        self.class.new(path).load
      end
    end

    def load_recipe_data_from_executable
      JSON.parse(execute)
    end

    def load_recipe_data_from_json
      JSON.parse(recipe_pathname.read)
    end

    def load_recipe_data_from_yaml
      YAML.load_file(recipe_pathname)
    end

    def recipe_pathname
      @recipe_pathname ||= Pathname.new(@recipe_path)
    end
  end
end
