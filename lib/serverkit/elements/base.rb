module Serverkit
  module Elements
    class Base
      # @param [Hash] variables
      def initialize(variables)
        @variables = variables
      end

      # @note For override.
      # @return [true, false]
      def valid?
        true
      end
    end
  end
end
