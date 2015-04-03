require "serverkit/loaders/base_loader"
require "serverkit/loaders/variables_loader"
require "serverkit/recipe"

module Serverkit
  module Loaders
    class RecipeLoader < BaseLoader
      DEFAULT_VARIABLES = {}

      # @param [String] path
      # @param [String, nil] variables_path
      def initialize(path, variables_path: nil)
        super(path)
        @variables_path = variables_path
      end

      private

      # @note Override
      def binding_for_erb
        ErbBindingContext.new(variables_data).binding
      end

      # @note Override to pass @variables_path
      def create_empty_loadable
        loaded_class.new({}, @variables_path)
      end

      def has_variables_path?
        !@variables_path.nil?
      end

      # @note Override to pass @variables_path
      def load_from_data
        loaded_class.new(load_data, @variables_path)
      end

      # @return [Serverkit::Variables]
      def load_variables
        Loaders::VariablesLoader.new(@variables_path).load
      end

      # @note Implementation
      def loaded_class
        Serverkit::Recipe
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
end
