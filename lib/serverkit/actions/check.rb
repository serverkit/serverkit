require "serverkit/actions/base"

module Serverkit
  module Actions
    class Check < Base
      def call
        recipe.elements.each do |element|
          element.backend = backend
          if element.check
            puts "[OK] #{element.name}"
          else
            puts "[NG] #{element.name}"
          end
        end
      end
    end
  end
end
