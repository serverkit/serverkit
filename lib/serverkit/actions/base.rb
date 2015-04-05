require "etc"
require "net/ssh"
require "serverkit/errors/missing_recipe_path_argument_error"
require "serverkit/loaders/recipe_loader"
require "serverkit/recipe"
require "slop"
require "specinfra"

module Serverkit
  module Actions
    class Base
      # @param [Array] argv Command-line arguments given to serverkit executable
      def initialize(argv)
        @argv = argv
      end

      def call
        setup
        run
      end

      private

      def abort_with_errors
        abort recipe.errors.map { |error| "Error: #{error}" }.join("\n")
      end

      # @return [Array<Specinfra::Backend::Base>]
      def backends
        if options[:hosts]
          hosts.map do |host|
            backend_class.new(
              disable_sudo: true,
              host: host,
              ssh_options: {
                user: ssh_user_for(host),
              },
            )
          end
        else
          [backend_class.new]
        end
      end

      def backend_class
        if options[:hosts]
          Specinfra::Backend::Ssh
        else
          Specinfra::Backend::Exec
        end
      end

      def hosts
        options[:hosts].split(",")
      end

      # @param [Specinfra::Backend::Base]
      # @return [String]
      def host_for(backend)
        backend.get_config(:host) || "localhost"
      end

      # @return [Slop] Command-line options
      def options
        @options ||= Slop.parse!(@argv, help: true) do
          banner "Usage: serverkit ACTION [options]"
          on "--hosts=", "Pass hostname to execute command over SSH"
          on "--variables=", "Path to variables file for ERB recipe"
        end
      end

      def setup
        abort_with_errors unless recipe.valid?
      end

      # @return [Serverkit::Recipe]
      def recipe
        @recipe ||= Loaders::RecipeLoader.new(recipe_path, variables_path: options[:variables]).load
      end

      # @return [String, nil]
      def recipe_path
        @argv[1] or raise Errors::MissingRecipePathArgumentError
      end

      # @param [String] host
      # @return [String] User name used on SSH
      def ssh_user_for(host)
        Net::SSH::Config.for(host)[:user] || Etc.getlogin
      end
    end
  end
end
