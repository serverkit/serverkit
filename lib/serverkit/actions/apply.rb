require "serverkit/actions/base"
require "thread"

module Serverkit
  module Actions
    class Apply < Base
      # Apply recipe so that all backends have ideal states, then exit with 0 or 1
      def run
        if apply_resources
          exit
        else
          exit(1)
        end
      end

      private

      # @return [true, false] True if all backends have ideal states
      def apply_resources
        backends.map do |backend|
          Thread.new do
            resources = recipe.resources.map(&:clone).map do |resource|
              resource.backend = backend
              resource.run_apply
              backend.logger.report_apply_result_of(resource)
              resource
            end
            handlers = resources.select(&:notifiable?).flat_map(&:handlers).uniq.map(&:clone).each do |handler|
              handler.backend = backend
              handler.run_apply
              backend.logger.report_apply_result_of(handler)
            end
            resources + handlers
          end
        end.map(&:value).flatten.all?(&:successful?)
      end
    end
  end
end
