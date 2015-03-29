require "serverkit/actions/base"

module Serverkit
  module Actions
    class Apply < Base
      def call
        recipe.elements.each do |element|
          element.backend = backend
          if element.check
            puts "[SKIP] #{element.name}"
          else
            element.apply
            if element.check
              puts "[DONE] #{element.name}"
            else
              puts "[FAIL] #{element.name}"
            end
          end
        end
      end
    end
  end
end
