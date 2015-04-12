require "serverkit/actions/base"
require "thread"

module Serverkit
  module Actions
    class Check < Base
      def run
        backends.map do |backend|
          Thread.new do
            recipe.resources.map(&:clone).each do |resource|
              resource.backend = backend
              resource.run_check
              puts resource.inspect_check_result
            end
          end
        end.each(&:join)
      end
    end
  end
end
