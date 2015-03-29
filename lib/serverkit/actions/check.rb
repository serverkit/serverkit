require "serverkit/actions/base"

module Serverkit
  module Actions
    class Check < Base
      def call
        recipe.resources.each do |resource|
          resource.backend = backend
          if resource.check
            puts "[OK] #{resource.name}"
          else
            puts "[NG] #{resource.name}"
          end
        end
      end
    end
  end
end
