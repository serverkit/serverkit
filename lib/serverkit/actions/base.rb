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

      private

      def abort_with_errors
        abort recipe.errors.map { |error| "Error: #{error}" }.join("\n")
      end

      # @return [Specinfra::Backend::Base]
      def backend
        @backend ||= backend_class.new(backend_options)
      end

      def backend_class
        if host
          Specinfra::Backend::Ssh
        else
          Specinfra::Backend::Exec
        end
      end

      def backend_options
        {
          disable_sudo: true,
          host: host,
          ssh_options: {
            user: ssh_user,
          },
        }
      end

      def host
        options[:host]
      end

      # @return [Slop] Command-line options
      def options
        @options ||= Slop.parse!(@argv, help: true) do
          banner "Usage: serverkit ACTION [options]"
          on "--host=", "Pass hostname to use SSH"
          on "--variables=", "Path to variables file for ERB recipe"
        end
      end

      # @return [Serverkit::Recipe]
      def recipe
        @recipe ||= Loaders::RecipeLoader.new(recipe_path, variables_path: options[:variables]).load
      end

      # @return [String, nil]
      def recipe_path
        @argv[1] or raise Errors::MissingRecipePathArgumentError
      end

      # @return [String] User name used on SSH
      def ssh_user
        Net::SSH::Config.for(host)[:user] || Etc.getlogin
      end
    end
  end
end
