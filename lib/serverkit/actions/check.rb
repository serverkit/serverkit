require "serverkit/actions/base"

module Serverkit
  module Actions
    class Check < Base
      def run
        recipe.resources.each do |resource|
          backends.map do |backend|
            Thread.new do
              resource.backend = backend
              if resource.check
                puts "[ OK ] #{resource.id}"
              else
                puts "[ NG ] #{resource.id}"
              end
            end
          end.each(&:join)
        end
      end
    end
  end
end
