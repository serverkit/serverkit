require "serverkit/errors/base"

module Serverkit
  module Errors
    class NonExistentPathError < Base
      # @param [#to_s] path
      def initialize(path)
        @path = path
      end

      # @return [String]
      def to_s
        abort "No such file or directory `#{@path}`"
      end
    end
  end
end
