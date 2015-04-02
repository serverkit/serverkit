require "erb"
require "json"
require "pathname"
require "serverkit/variables"
require "tempfile"
require "yaml"

module Serverkit
  class VariablesLoader
    YAML_EXTNAMES = [".yaml", ".yml"]

    # @param [String] variables_path
    def initialize(variables_path)
      @variables_path = variables_path
    end

    # @return [Serverkit::Variables]
    def load
      case
      when has_directory_variables_path?
        load_variables_from_directory
      when has_erb_variables_path?
        load_variables_from_erb
      else
        Variables.new(load_variables_data)
      end
    end

    private

    # @return [String] This executable must print variables in JSON format into standard output
    def execute_variables
      `#{variables_pathname}`
    end

    # @return [String]
    def expand_erb
      ERB.new(variables_pathname.read).result
    end

    # @return [String]
    def expanded_erb_path_suffix
      "." + variables_pathname.basename(".erb").to_s.split(".", 2).last
    end

    # @note Memoizing to prevent GC
    # @return [Tempfile]
    def expanded_variables_tempfile
      @expanded_variables_tempfile ||= Tempfile.new(["", expanded_erb_path_suffix]).tap do |tempfile|
        tempfile << expand_erb
        tempfile.close
        tempfile
      end
    end

    def has_directory_variables_path?
      variables_pathname.directory?
    end

    def has_erb_variables_path?
      variables_pathname.extname == ".erb"
    end

    def has_executable_variables_path?
      variables_pathname.executable?
    end

    def has_yaml_variables_path?
      YAML_EXTNAMES.include?(variables_pathname.extname)
    end

    # @return [Array<Serverkit::Variables>]
    def load_variables_collection_from_directory
      Dir.glob(variables_pathname.join("*")).sort.flat_map do |path|
        self.class.new(path).load
      end
    end

    # @return [Hash]
    def load_variables_data
      case
      when has_executable_variables_path?
        load_variables_data_from_executable
      when has_yaml_variables_path?
        load_variables_data_from_yaml
      else
        load_variables_data_from_json
      end
    end

    # @return [Serverkit::Variables]
    def load_variables_from_directory
      load_variables_collection_from_directory.inject(Variables.new, :merge)
    end

    # @return [Hash]
    def load_variables_data_from_executable
      JSON.parse(execute)
    end

    # @return [Hash]
    def load_variables_data_from_json
      JSON.parse(variables_pathname.read)
    end

    # @return [Hash]
    def load_variables_data_from_yaml
      YAML.load_file(variables_pathname)
    end

    # @return [Serverkit::Variables]
    def load_variables_from_erb
      self.class.new(expanded_variables_tempfile.path).load
    end

    # @return [Pathname]
    def variables_pathname
      @variables_pathname ||= Pathname.new(@variables_path)
    end
  end
end
