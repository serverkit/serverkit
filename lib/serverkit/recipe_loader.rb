require "erb"
require "json"
require "pathname"
require "serverkit/recipe"
require "serverkit/variables_loader"
require "tempfile"
require "yaml"

module Serverkit
  class RecipeLoader
    DEFAULT_VARIABLES = {}

    YAML_EXTNAMES = [".yaml", ".yml"]

    # @param [String] recipe_path
    # @param [String, nil] variables_path Variables are used to interpolate ERB recipe
    def initialize(recipe_path, variables_path: nil)
      @recipe_path = recipe_path
      @variables_path = variables_path
    end

    # @todo Care Error::ENOENT error
    # @return [Serverkit::Recipe]
    def load
      case
      when has_directory_recipe_path?
        load_recipe_from_directory
      when has_erb_recipe_path?
        load_recipe_from_erb
      else
        Recipe.new(load_recipe_data)
      end
    end

    private

    def create_binding_for_erb
      ErbBindingContext.new(variables_data.to_hash).binding
    end

    # @return [String]
    def expand_erb
      ERB.new(recipe_pathname.read).result(create_binding_for_erb)
    end

    # @return [String]
    def expanded_erb_path_suffix
      "." + recipe_pathname.basename(".erb").to_s.split(".", 2).last
    end

    # @note Memoizing to prevent GC
    # @return [Tempfile]
    def expanded_recipe_tempfile
      @expanded_recipe_tempfile ||= Tempfile.new(["", expanded_erb_path_suffix]).tap do |tempfile|
        tempfile << expand_erb
        tempfile.close
        tempfile
      end
    end

    # @return [String] This executable must print reicpe in JSON format into standard output
    def execute_recipe
      `#{recipe_pathname}`
    end

    def has_directory_recipe_path?
      recipe_pathname.directory?
    end

    def has_erb_recipe_path?
      recipe_pathname.extname == ".erb"
    end

    def has_executable_recipe_path?
      recipe_pathname.executable?
    end

    def has_variables_path?
      !@variables_path.nil?
    end

    def has_yaml_recipe_path?
      YAML_EXTNAMES.include?(recipe_pathname.extname)
    end

    # @return [Hash]
    def load_recipe_data
      case
      when has_executable_recipe_path?
        load_recipe_data_from_executable
      when has_erb_recipe_path?
        load_recipe_data_from_erb
      when has_yaml_recipe_path?
        load_recipe_data_from_yaml
      else
        load_recipe_data_from_json
      end
    end

    # @return [Serverkit::Recipe]
    def load_recipe_from_directory
      load_recipes_from_directory.inject(Recipe.new, :merge)
    end

    # @return [Serverkit::Recipe]
    def load_recipe_from_erb
      self.class.new(expanded_recipe_tempfile.path).load
    end

    # @return [Array<Serverkit::Recipe>]
    def load_recipes_from_directory
      Dir.glob(recipe_pathname.join("*")).sort.flat_map do |path|
        self.class.new(path).load
      end
    end

    # @return [Hash]
    def load_recipe_data_from_executable
      JSON.parse(execute_recipe)
    end

    # @return [Hash]
    def load_recipe_data_from_json
      JSON.parse(recipe_pathname.read)
    end

    # @return [Hash]
    def load_recipe_data_from_yaml
      YAML.load_file(recipe_pathname)
    end

    # @return [Hash]
    def load_variables
      VariablesLoader.new(@variables_path).load
    end

    # @return [Pathname]
    def recipe_pathname
      @recipe_pathname ||= Pathname.new(@recipe_path)
    end

    # @return [Hash]
    def variables_data
      @variables ||= begin
        if has_variables_path?
          load_variables.to_hash
        else
          DEFAULT_VARIABLES.dup
        end
      end
    end

    class ErbBindingContext
      attr_reader :variables

      # @param [hash] variables
      def initialize(variables)
        @variables = variables
      end

      # @note Change method visibility to public
      def binding
        super
      end
    end
  end
end
