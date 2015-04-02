require "json"

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
      if has_directory_path?
        load_recipe_from_directory
      else
        Recipe.new(load_data)
      end
    end

    private

    # @return [String] This executable must print reicpe in JSON format into standard output
    def execute
      `#{@recipe_path}`
    end

    # @return [String]
    def extname
      @extname ||= File.extname(@recipe_path)
    end

    def has_directory_path?
      File.directory?(@recipe_path)
    end

    def has_executable_path?
      File.executable?(@recipe_path)
    end

    def has_yaml_path?
      YAML_EXTNAMES.include?(extname)
    end

    def load_data
      case
      when has_executable_path?
        load_data_from_executable
      when has_yaml_path?
        load_data_from_yaml
      else
        load_data_from_json
      end
    end

    def load_recipe_from_directory
      load_recipes_from_directory.inject(Recipe.new, :merge)
    end

    def load_recipes_from_directory
      Dir.glob(File.join(@recipe_path, "*")).sort.flat_map do |path|
        self.class.new(path).load
      end
    end

    def load_data_from_executable
      JSON.parse(execute)
    end

    def load_data_from_json
      JSON.parse(File.read(@recipe_path))
    end

    def load_data_from_yaml
      YAML.load_file(@recipe_path)
    end
  end
end
