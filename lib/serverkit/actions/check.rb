require "serverkit/actions/base"

module Serverkit
  module Actions
    class Check < Base
      def run
        backends.map do |backend|
          recipe.resources.each do |resource|
            resource.backend = backend
            result = resource.check ? "OK" : "NG"
            puts "[ #{result} ] #{resource.id} on #{host_for(backend)}"
          end
        end
      end
    end
  end
end
