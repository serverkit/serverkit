module Serverkit
  module Actions
    class Apply
      # @param [Hash] options
      def initialize(options)
        @options = options
      end

      # @todo
      def call
        puts "#{self.class}##{__method__} called"
      end
    end
  end
end
