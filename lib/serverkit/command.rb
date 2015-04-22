require "rainbow"
require "serverkit/actions/apply"
require "serverkit/actions/check"
require "serverkit/actions/inspect"
require "serverkit/actions/validate"
require "serverkit/errors/missing_action_name_argument_error"
require "serverkit/errors/missing_recipe_path_argument_error"
require "serverkit/errors/unknown_action_name_error"

module Serverkit
  # Command clsas takes care of command line interface.
  # It builds and runs an Action object from given command line arguements.
  class Command
    LOG_LEVELS_TABLE = {
      "" => Logger::INFO,
      "0" => Logger::DEBUG,
      "1" => Logger::INFO,
      "2" => Logger::WARN,
      "3" => Logger::ERROR,
      "4" => Logger::FATAL,
      "DEBUG" => Logger::DEBUG,
      "ERROR" => Logger::ERROR,
      "FATAL" => Logger::FATAL,
      "INFO" => Logger::INFO,
      "WARN" => Logger::WARN,
    }

    # @param [Array<String>] argv
    def initialize(argv)
      @argv = argv
    end

    def call
      setup
      case action_name
      when nil
        raise Errors::MissingActionNameArgumentError
      when "apply"
        apply
      when "check"
        check
      when "inspect"
        _inspect
      when "validate"
        validate
      else
        raise Errors::UnknownActionNameError, action_name
      end
    rescue Errors::Base, Psych::SyntaxError, Slop::MissingArgumentError, Slop::MissingOptionError => exception
      abort "Error: #{exception}"
    end

    private

    # @note #inspect is reserved ;(
    def _inspect
      Actions::Inspect.new(action_options).call
    end

    # @return [String, nil]
    def action_name
      @argv.first
    end

    # @return [Hash<Symbol => String>]
    def action_options
      {
        hosts: hosts,
        log_level: log_level,
        recipe_path: recipe_path,
        variables_path: variables_path,
      }.reject do |key, value|
        value.nil?
      end
    end

    def apply
      Actions::Apply.new(action_options).call
    end

    def check
      Actions::Check.new(action_options).call
    end

    # @note This options are commonly used from all actions for now, however,
    #   someday a new action that requires options might appear.
    # @return [Slop]
    def command_line_options
      @command_line_options ||= Slop.parse!(@argv, help: true) do
        banner "Usage: serverkit ACTION [options]"
        on "--hosts=", "Hostname to execute command over SSH"
        on "--log-level=", "Log level (DEBUG, INFO, WARN, ERROR, FATAL)"
        on "--no-color", "Disable coloring"
        on "--variables=", "Path to variables file for ERB recipe"
      end
    end

    # @return [String, nil]
    def hosts
      command_line_options["hosts"]
    end

    # @return [Fixnum]
    def log_level
      LOG_LEVELS_TABLE[command_line_options["log-level"].to_s.upcase] || ::Logger::UNKNOWN
    end

    # @return [String]
    def recipe_path
      @argv[1] or raise Errors::MissingRecipePathArgumentError
    end

    def setup
      ::Rainbow.enabled = !command_line_options["no-color"]
    end

    def validate
      Actions::Validate.new(action_options).call
    end

    def variables_path
      command_line_options["variables"]
    end
  end
end
