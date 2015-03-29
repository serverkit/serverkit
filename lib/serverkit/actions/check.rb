require "serverkit/recipe"
require "specinfra"

module Serverkit
  module Actions
    class Check
      # @param [Hash] options
      def initialize(options)
        @options = options
      end

      # @todo
      def call
        recipe.elements.each do |element|
          element.backend = backend
          if element.check
            puts "[OK] #{element.name}"
          else
            puts "[NG] #{element.name}"
          end
        end
      end

      private

      # @return [Specinfra::Backend::Base]
      def backend
        @backend ||= backend_class.new
      end

      private

      # @return [Class]
      def backend_class
        if recipe.ssh?
          Specinfra::Backend::Ssh
        else
          Specinfra::Backend::Exec
        end
      end

      # @return [Serverkit::Recipe]
      def recipe
        @recipe ||= Recipe.load_from_path(@options[:recipe])
      end
    end
  end
end
