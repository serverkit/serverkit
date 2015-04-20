require "erb"
require "serverkit/loaders/variables_loader"
require "serverkit/resources/remote_file"

module Serverkit
  module Resources
    class Template < RemoteFile
      DEFAULT_VARIABLES_DATA = {}

      private

      # @note Override
      def content
        @content ||= erb.result(variables.to_mash.binding)
      end

      # @return [ERB]
      def erb
        _erb = ::ERB.new(template_content, nil, "-")
        _erb.filename = source
        _erb
      end

      # @return [String] ERB content
      def template_content
        @template ||= ::File.read(source)
      end

      # @note Override
      def update_entry
        send_content_to_destination
      end

      # @return [Serverkit::Variables]
      def variables
        @variables ||= begin
          if recipe.variables_path
            Loaders::VariablesLoader.new(recipe.variables_path).load
          else
            Variables.new(DEFAULT_VARIABLES_DATA.dup)
          end
        end
      end
    end
  end
end
