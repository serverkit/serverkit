require "active_support/core_ext/hash/deep_merge"

module Serverkit
  class Variables
    attr_reader :variables_data

    # @param [Hash] variables_data
    def initialize(variables_data = {})
      @variables_data = variables_data
    end

    # @param [Serverkit::Variables] variables
    # @return [Serverkit::Variables]
    def merge(variables)
      self.class.new(
        variables_data.deep_merge(variables.variables_data) do |key, a, b|
          if a.is_a?(Array)
            a | b
          else
            b
          end
        end
      )
    end

    # @return [Hash]
    def to_hash
      @variables_data.dup
    end
  end
end
