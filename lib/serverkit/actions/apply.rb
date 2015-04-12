require "serverkit/actions/base"
require "thread"

module Serverkit
  module Actions
    class Apply < Base
      def run
        backends.map do |backend|
          Thread.new do
            recipe.resources.map(&:clone).map do |resource|
              resource.backend = backend
              resource.run_apply
              puts resource.inspect_apply_result
              resource
            end.select(&:notifiable?).flat_map(&:handlers).uniq.map(&:dup).each do |handler|
              handler.backend = backend
              handler.run_apply
              puts handler.inspect_apply_result
            end
          end
        end.each(&:join)
      end
    end
  end
end
