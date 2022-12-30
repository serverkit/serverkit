require "erb"
require "json"
require "pathname"
require "serverkit/errors/non_existent_path_error"
require "tempfile"
require "yaml"

module Serverkit
  module Loaders
    class BaseLoader
      YAML_EXTNAMES = [".yaml", ".yml"].freeze

      # @param [String] path
      def initialize(path)
        @path = path
      end

      def load
        if !pathname.exist?
          raise Errors::NonExistentPathError, pathname
        elsif has_directory_path?
          load_from_directory
        elsif has_erb_path?
          load_from_erb
        else
          load_from_data
        end
      end

      private

      # @return [Binding]
      def binding_for_erb
        TOPLEVEL_BINDING
      end

      # @note For override
      def create_empty_loadable
        loaded_class.new({})
      end

      # @return [ERB]
      def erb
        _erb = ERB.new(pathname.read, trim_mode: "-")
        _erb.filename = pathname.to_s
        _erb
      end

      # @return [String]
      def execute
        `#{pathname}`
      end

      # @return [String]
      def expand_erb
        erb.result(binding_for_erb)
      end

      # @return [String]
      def expanded_erb_path_suffix
        "." + pathname.basename(".erb").to_s.split(".", 2).last
      end

      # @note Memoizing to prevent GC
      # @return [Tempfile]
      def expanded_erb_tempfile
        @expanded_erb_tempfile ||= Tempfile.new(["", expanded_erb_path_suffix]).tap do |tempfile|
          tempfile << expand_erb
          tempfile.close
        end
      end

      def has_directory_path?
        pathname.directory?
      end

      def has_erb_path?
        pathname.extname == ".erb"
      end

      def has_executable_path?
        pathname.executable?
      end

      def has_yaml_path?
        YAML_EXTNAMES.include?(pathname.extname)
      end

      # @return [Hash]
      def load_data
        if has_executable_path?
          load_data_from_executable
        elsif has_yaml_path?
          load_data_from_yaml
        else
          load_data_from_json
        end
      end

      def load_from_data
        loaded_class.new(load_data)
      end

      def load_from_directory
        loads_from_directory.inject(create_empty_loadable, :merge)
      end

      def load_from_erb
        self.class.new(expanded_erb_tempfile.path).load
      end

      # @return [Array]
      def loads_from_directory
        Dir.glob(pathname.join("*")).sort.flat_map do |path|
          self.class.new(path).load
        end
      end

      # @return [Hash]
      def load_data_from_executable
        JSON.parse(execute)
      end

      # @return [Hash]
      def load_data_from_json
        JSON.parse(pathname.read)
      end

      # @return [Hash]
      def load_data_from_yaml
        YAML.load_file(pathname)
      end

      # @return [Pathname]
      def pathname
        @pathname ||= Pathname.new(@path)
      end
    end
  end
end
