require "serverkit/actions/base"
require "thread"

module Serverkit
  module Actions
    class Check < Base
      def run
        backends.map do |backend|
          Thread.new do
            recipe.resources.map(&:dup).each do |resource|
              resource.backend = backend
              result = resource.check ? "OK" : "NG"
              puts "[ #{result} ] #{resource.id} on #{host_for(backend)}"
            end
          end
        end.each(&:join)
      end
    end
  end
end
