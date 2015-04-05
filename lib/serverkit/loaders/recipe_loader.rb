require "serverkit/loaders/base_loader"
require "serverkit/loaders/variables_loader"
require "serverkit/recipe"

module Serverkit
  module Loaders
    class RecipeLoader < BaseLoader
      DEFAULT_VARIABLES_DATA = {}

      # @param [String] path
      # @param [String, nil] variables_path
      def initialize(path, variables_path: nil)
        super(path)
        @variables_path = variables_path
      end

      private

      # @note Override
      # @return [Binding]
      def binding_for_erb
        variables.to_mash.binding
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

      # @return [Serverkit::Variables]
      def variables
        @variables ||= begin
          if has_variables_path?
            load_variables
          else
            Variables.new(DEFAULT_VARIABLES_DATA.dup)
          end
        end
      end
    end
  end
end
