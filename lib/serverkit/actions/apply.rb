require "serverkit/actions/base"

module Serverkit
  module Actions
    class Apply < Base
      def call
        recipe.resources.each do |resource|
          resource.backend = backend
          if resource.check
            puts "[SKIP] #{resource.name}"
          else
            resource.apply
            if resource.check
              puts "[DONE] #{resource.name}"
            else
              puts "[FAIL] #{resource.name}"
            end
          end
        end
      end
    end
  end
end
