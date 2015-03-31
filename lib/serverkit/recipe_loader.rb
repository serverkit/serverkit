require "json"

module Serverkit
  class RecipeLoader
    YAML_EXTNAMES = [".yaml", ".yml"]

    # @param [String] path
    def initialize(path)
      @path = path
    end

    # @return [Object] A Hash in normal case
    def load
      case
      when has_executable_path?
        load_from_executable
      when has_yaml_path?
        load_from_yaml
      else
        load_from_json
      end
    end

    private

    # @return [String] This executable must print reicpe in JSON format into standard output
    def execute
      `#{@path}`
    end

    # @return [String]
    def extname
      @extname ||= File.extname(@path)
    end

    def has_executable_path?
      File.executable?(@path)
    end

    def has_yaml_path?
      YAML_EXTNAMES.include?(extname)
    end

    def load_from_executable
      JSON.parse(execute)
    end

    def load_from_json
      JSON.parse(File.read(@path))
    end

    def load_from_yaml
      YAML.load_file(@path)
    end
  end
end
