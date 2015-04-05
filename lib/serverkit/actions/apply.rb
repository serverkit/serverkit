require "serverkit/actions/base"
require "thread"

module Serverkit
  module Actions
    class Apply < Base
      def run
        backends.map do |backend|
          Thread.new do
            recipe.resources.map(&:dup).each do |resource|
              resource.backend = backend
              if resource.diff
                puts "[SKIP] #{resource.id} on #{host_for(backend)}"
              else
                resource.apply
                result = resource.diff ? "DONE" : "FAIL"
                puts "[#{result}] #{resource.id} on #{host_for(backend)}"
              end
            end
          end
        end.each(&:join)
      end
    end
  end
end
