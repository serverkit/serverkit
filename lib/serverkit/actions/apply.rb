require "serverkit/actions/base"
require "thread"

module Serverkit
  module Actions
    class Apply < Base
      def run
        successful = backends.map do |backend|
          Thread.new do
            resources = recipe.resources.map(&:clone).map do |resource|
              resource.backend = backend
              resource.run_apply
              puts resource.inspect_apply_result
              resource
            end
            handlers = resources.select(&:notifiable?).flat_map(&:handlers).uniq.map(&:clone).map do |handler|
              handler.backend = backend
              handler.run_apply
              puts handler.inspect_apply_result
              handler
            end
            resources + handlers
          end
        end.map(&:value).flatten.all?(&:successful?)
        if successful
          exit
        else
          exit(1)
        end
      end
    end
  end
end
