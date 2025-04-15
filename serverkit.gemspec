# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "serverkit/version"

Gem::Specification.new do |spec|
  spec.name                  = "serverkit"
  spec.version               = Serverkit::VERSION
  spec.authors               = ["Ryo Nakamura"]
  spec.email                 = ["r7kamura@gmail.com"]
  spec.summary               = "Assemble servers from your recipe."
  spec.homepage              = "https://github.com/serverkit/serverkit"
  spec.license               = "MIT"
  spec.files                 = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir                = "bin"
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths         = ["lib"]
  spec.required_ruby_version = ">= 2.6.0"

  spec.add_runtime_dependency "activemodel"
  spec.add_runtime_dependency "activesupport", ">= 5.0.0"
  spec.add_runtime_dependency "bundler"
  spec.add_runtime_dependency "hashie"
  spec.add_runtime_dependency "highline"
  spec.add_runtime_dependency "rainbow"
  spec.add_runtime_dependency "slop", "~> 3.4"
  spec.add_runtime_dependency "specinfra", ">= 2.31.0"
  spec.add_runtime_dependency "unix-crypt"
end
