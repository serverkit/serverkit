require "logger"

module Serverkit
  # A logger class that has a simple formatter by default.
  class Logger < ::Logger
    DEFAULT_LEVEL = INFO

    def initialize(*)
      super
      self.formatter = Formatter.new
    end

    # @param [Serverkit::Resources::Base]
    def report_apply_result_of(resource)
      message = ResourceApplyStateView.new(resource).to_s
      info(message)
    end

    # @param [Serverkit::Resources::Base]
    def report_check_result_of(resource)
      message = ResourceCheckStateView.new(resource).to_s
      info(message)
    end

    class Formatter
      def call(severity, time, program_name, message)
        if message.is_a?(String)
          message
        else
          message.inspect
        end.gsub(/\n\z/, "") + "\n"
      end
    end

    class ResourceStateView
      def initialize(resource)
        @resource = resource
      end

      def to_s
        "[#{result_tag}] #{@resource.type} #{@resource.id} on #{backend_host}"
      end

      private

      def backend_host
        @resource.backend.host
      end
    end

    class ResourceApplyStateView < ResourceStateView
      private

      # @return [String]
      def result_tag
        case @resource.recheck_result
        when nil
          "SKIP"
        when false
          "FAIL"
        else
          "DONE"
        end
      end
    end

    class ResourceCheckStateView < ResourceStateView
      private

      # @return [String]
      def result_tag
        if @resource.check_result
          " OK "
        else
          " NG "
        end
      end
    end
  end
end
