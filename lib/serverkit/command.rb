require "serverkit/actions/apply"
require "serverkit/actions/diff"
require "serverkit/actions/inspect"
require "serverkit/actions/validate"
require "serverkit/errors/missing_action_name_argument_error"
require "serverkit/errors/missing_recipe_path_argument_error"
require "serverkit/errors/unknown_action_name_error"

module Serverkit
  class Command
    # @param [Array<String>] argv
    def initialize(argv)
      @argv = argv
    end

    def call
      case action_name
      when nil
        raise Errors::MissingActionNameArgumentError
      when "apply"
        apply
      when "diff"
        diff
      when "inspect"
        _inspect
      when "validate"
        validate
      else
        raise Errors::UnknownActionNameError
      end
    rescue Errors::Base, Slop::MissingArgumentError, Slop::MissingOptionError => exception
      abort "Error: #{exception}"
    end

    private

    # @return [String, nil]
    def action_name
      @argv.first
    end

    def apply
      Actions::Apply.new(@argv).call
    end

    def diff
      Actions::Diff.new(@argv).call
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
