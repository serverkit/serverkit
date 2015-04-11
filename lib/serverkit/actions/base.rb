require "bundler"
require "etc"
require "net/ssh"
require "serverkit/loaders/recipe_loader"
require "serverkit/recipe"
require "slop"
require "specinfra"

module Serverkit
  module Actions
    class Base
      # @param [String, nil] hosts
      # @param [String] recipe_path
      # @param [Stirng, nil] variables_path
      def initialize(hosts: nil, recipe_path: nil, variables_path: nil)
        @hosts = hosts
        @recipe_path = recipe_path
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

      # @return [Array<Specinfra::Backend::Base>]
      def backends
        if @hosts
          hosts.map do |host|
            backend_class.new(
              disable_sudo: true,
              host: host,
              ssh_options: {
                user: ssh_user_for(host),
              }.merge(ssh_options),
            )
          end
        else
          [backend_class.new]
        end
      end

      def backend_class
        if @hosts
          Specinfra::Backend::Ssh
        else
          Specinfra::Backend::Exec
        end
      end

      def bundle
        Bundler.require(:default)
      rescue Bundler::GemfileNotFound
      end

      def hosts
        @options[:hosts].split(",")
      end

      def setup
        bundle
        abort_with_errors unless recipe.valid?
      end

      # @return [Serverkit::Recipe]
      def recipe
        @recipe ||= Loaders::RecipeLoader.new(@recipe_path, variables_path: @variables_path).load
      end

      # @param [String] host
      # @return [String] User name used on SSH
      def ssh_user_for(host)
        Net::SSH::Config.for(host)[:user] || Etc.getlogin
      end
    end
  end
end
