require "serverkit/actions/apply"
require "serverkit/actions/check"
require "serverkit/actions/inspect"
require "serverkit/actions/validate"
require "slop"

module Serverkit
  class Command
    # @param [Array<String>] argv
    def initialize(argv)
      @argv = argv
    end

    def call
      case action_name
      when nil
        abort_for_missing_action_name
      when "apply"
        apply
      when "check"
        check
      when "inspect"
        _inspect
      when "validate"
        validate
      else
        abort_for_unknown_action_name
      end
    rescue Slop::MissingOptionError => exception
      abort "Error: #{exception}"
    end

    private

    def abort_for_missing_action_name
      abort "Error: Missing action name"
    end

    def abort_for_unknown_action_name
      abort "Error: Unknown action name `#{action_name}`"
    end

    # @return [String, nil]
    def action_name
      @argv.first
    end

    def apply
      Actions::Apply.new(@argv).call
    end

    def check
      Actions::Check.new(@argv).call
    end

    # @note #inspect is reserved ;(
    def _inspect
      Actions::Inspect.new(@argv).call
    end

    def validate
      Actions::Validate.new(@argv).call
    end
  end
end
