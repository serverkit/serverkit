require "etc"
require "net/ssh"
require "serverkit/backends/base_backend"
require "specinfra"

module Serverkit
  module Backends
    class SshBackend < BaseBackend
      DEFAULT_SSH_OPTIONS = {}

      attr_reader :host

      # @param [String] host
      # @param [Hash] ssh_options
      def initialize(host: nil, ssh_options: nil, **args)
        super(**args)
        @host = host
        @ssh_options = ssh_options
      end

      private

      # @return [Specinfra::Backend::Ssh]
      def specinfra_backend
        @specinfra_backend ||= ::Specinfra::Backend::Ssh.new(
          host: host,
          ssh_options: ssh_options,
          request_pty: true,
        )
      end

      # @return [Hash]
      def ssh_options
        { user: user }.merge(@ssh_options || DEFAULT_SSH_OPTIONS)
      end

      # @return [String]
      def user
        ::Net::SSH::Config.for(@host)[:user] || ::Etc.getlogin
      end
    end
  end
end
