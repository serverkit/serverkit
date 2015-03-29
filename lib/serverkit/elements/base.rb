module Serverkit
  module Elements
    class Base
      # @param [Hash] properties
      def initialize(properties)
        @properties = properties
      end

      # @note Override this
      # @param [Specinfra::Backend::Base] backend
      # @return [true, false]
      def check(backend)
        raise NotImplementedError
      end

      # @return [String]
      def name
        @properties["name"]
      end
    end
  end
end
