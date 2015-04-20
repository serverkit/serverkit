require "active_support/core_ext/hash/deep_merge"
require "hashie/mash"

module Serverkit
  class Variables
    attr_reader :variables_data

    # @param [Hash] variables_data
    def initialize(variables_data)
      @variables_data = variables_data
    end

    # @param [Serverkit::Variables] variables
    # @return [Serverkit::Variables]
    def merge(variables)
      self.class.new(variables_data.deep_merge(variables.variables_data))
    end

    # @return [Hashie::Mash]
    def to_mash
      BindableMash.new(@variables_data.dup)
    end

    class BindableMash < Hashie::Mash
      DEFAULT_PROC = -> (hash, key) do
        raise KeyError, "key not found: #{key.inspect} (perhaps variables are wrong?)"
      end

      # @note Override to raise KeyError on missing key
      def initialize(*, &block)
        super
        self.default_proc = DEFAULT_PROC
      end

      # @note Override visibility from private to public
      def binding
        super
      end
    end
  end
end
