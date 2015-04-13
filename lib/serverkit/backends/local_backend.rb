require "serverkit/backends/base_backend"
require "specinfra"

module Serverkit
  module Backends
    class LocalBackend < BaseBackend
      HOST = "localhost"

      # @note Override
      def host
        HOST
      end

      private

      # @return [Specinfra::Backend::Exec]
      def specinfra_backend
        @specinfra_backend ||= Specinfra::Backend::Exec.new
      end
    end
  end
end
