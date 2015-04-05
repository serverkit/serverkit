require "serverkit/errors/base"

module Serverkit
  module Errors
    class UnknownActionNameError < Base
      # @param [String] action_name
      def initialize(action_name)
        @action_name = action_name
      end

      # @return [String]
      def to_s
        abort "Unknown action name `#{@action_name}`"
      end
    end
  end
end
