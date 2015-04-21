require "active_support/core_ext/string/inflections"
require "serverkit/resources/command"
require "serverkit/resources/directory"
require "serverkit/resources/file"
require "serverkit/resources/git"
require "serverkit/resources/group"
require "serverkit/resources/line"
require "serverkit/resources/missing"
require "serverkit/resources/nothing"
require "serverkit/resources/package"
require "serverkit/resources/recipe"
require "serverkit/resources/remote_file"
require "serverkit/resources/service"
require "serverkit/resources/symlink"
require "serverkit/resources/template"
require "serverkit/resources/unknown"
require "serverkit/resources/user"

module Serverkit
  class ResourceBuilder
    # @param [Serverkit::Recipe] recipe
    # @param [Hash] attributes
    def initialize(recipe, attributes)
      @attributes = attributes
      @recipe = recipe
    end

    # @return [Serverkit::Resources::Base]
    def build
      resource_class.new(@recipe, @attributes)
    end

    private

    # @return [Array<Class>]
    def available_resource_classes
      Resources.constants.select do |constant_name|
        constant = Resources.const_get(constant_name)
        constant < Resources::Base && !constant.abstract_class?
      end
    end

    def has_known_type?
      available_resource_classes.map(&:to_s).include?(resource_class_name)
    end

    # @return [Class]
    def resource_class
      case
      when type.nil?
        Resources::Missing
      when has_known_type?
        Resources.const_get(resource_class_name, false)
      else
        Resources::Unknown
      end
    end

    # @return [String] (e.g. "File", "Symlink")
    def resource_class_name
      type.to_s.camelize
    end

    # @note Expected to return String in normal case
    # @return [Object] (e.g. "file", "symlink")
    def type
      @attributes["type"]
    end
  end
end
