require "serverkit/loaders/base_loader"
require "serverkit/variables"

module Serverkit
  module Loaders
    class VariablesLoader < BaseLoader
      private

      # @note Implementation
      def loaded_class
        Serverkit::Variables
      end
    end
  end
end
