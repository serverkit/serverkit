require "serverkit/actions/base"

module Serverkit
  module Actions
    class Apply < Base
      def call
        recipe.resources.each do |resource|
          resource.backend = backend
          if resource.check
            puts "[SKIP] #{resource.id}"
          else
            resource.apply
            if resource.check
              puts "[DONE] #{resource.id}"
            else
              puts "[FAIL] #{resource.id}"
            end
          end
        end
      end
    end
  end
end
