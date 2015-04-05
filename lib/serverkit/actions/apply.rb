require "serverkit/actions/base"

module Serverkit
  module Actions
    class Apply < Base
      def run
        backends.map do |backend|
          recipe.resources.each do |resource|
            resource.backend = backend
            if resource.check
              puts "[SKIP] #{resource.id} on #{host_for(backend)}"
            else
              resource.apply
              result = resource.check ? "DONE" : "FAIL"
              puts "[#{result}] #{resource.id} on #{host_for(backend)}"
            end
          end
        end
      end
    end
  end
end
