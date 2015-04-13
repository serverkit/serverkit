require "serverkit/actions/base"
require "thread"

module Serverkit
  module Actions
    class Check < Base
      def run
        successful = backends.map do |backend|
          Thread.new do
            recipe.resources.map(&:clone).map do |resource|
              resource.backend = backend
              resource.run_check
              puts resource.inspect_check_result
              resource
            end
          end
        end.map(&:value).flatten.all?(&:successful?)
        if successful
          exit
        else
          exit(1)
        end
      end
    end
  end
end
