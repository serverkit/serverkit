require "serverkit/actions/base"
require "thread"

module Serverkit
  module Actions
    class Check < Base
      # Check if all backends have ideal states, then exit with exit-code 0 or 1
      def run
        if check_resources
          exit
        else
          exit(1)
        end
      end

      private

      # @return [true, false] True if all backends have ideal states
      def check_resources
        backends.map do |backend|
          Thread.new do
            recipe.resources.map(&:clone).map do |resource|
              resource.backend = backend
              resource.run_check
              backend.logger.report_check_result_of(resource)
              resource
            end
          end
        end.map(&:value).flatten.all?(&:successful?)
      end
    end
  end
end
