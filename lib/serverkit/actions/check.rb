require "serverkit/actions/base"

module Serverkit
  module Actions
    class Check < Base
      def call
        recipe.resources.each do |resource|
          resource.backend = backend
          if resource.check
            puts "[OK] #{resource.id}"
          else
            puts "[NG] #{resource.id}"
          end
        end
      end
    end
  end
end
