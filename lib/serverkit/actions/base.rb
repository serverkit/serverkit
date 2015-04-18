require "bundler"
require "logger"
require "serverkit/backends/local_backend"
require "serverkit/backends/ssh_backend"
require "serverkit/loaders/recipe_loader"
require "serverkit/recipe"
require "slop"
require "specinfra"

module Serverkit
  module Actions
    class Base
      DEFAULT_LOG_LEVEL = ::Logger::INFO

      # @param [String, nil] hosts
      # @param [Fixnum] log_level
      # @param [String] recipe_path
      # @param [Hash, nil] ssh_options For override default ssh options
      # @param [Stirng, nil] variables_path
      def initialize(hosts: nil, log_level: nil, recipe_path: nil, ssh_options: nil, variables_path: nil)
        @hosts = hosts
        @log_level = log_level
        @recipe_path = recipe_path
        @ssh_options = ssh_options
        @variables_path = variables_path
      end

      def call
        setup
        run
      end

      private

      def abort_with_errors
        abort recipe.errors.map { |error| "Error: #{error}" }.join("\n")
      end

      # @return [Array<Serverkit::Backends::Base>]
      def backends
        if has_hosts?
          hosts.map do |host|
            Backends::SshBackend.new(
              host: host,
              log_level: @log_level,
              ssh_options: @ssh_options,
            )
          end
        else
          [Backends::LocalBackend.new(log_level: @log_level)]
        end
      end

      def bundle
        Bundler.require(:default)
      rescue Bundler::GemfileNotFound
      end

      def has_hosts?
        !@hosts.nil?
      end

      # @return [Array<String>, nil]
      def hosts
        if has_hosts?
          @hosts.split(",")
        end
      end

      def setup
        bundle
        abort_with_errors unless recipe.valid?
      end

      # @return [Serverkit::Recipe]
      def recipe
        @recipe ||= Loaders::RecipeLoader.new(@recipe_path, variables_path: @variables_path).load
      end
    end
  end
end
