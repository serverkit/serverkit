# frozen_string_literal: true

require_relative "lib/serverkit/version"

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

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/serverkit/serverkit"
  spec.metadata["changelog_uri"]   = "https://github.com/serverkit/serverkit/releases"

  spec.add_dependency "activemodel"
  spec.add_dependency "activesupport", ">= 5.0.0"
  spec.add_dependency "bundler"
  spec.add_dependency "hashie"
  spec.add_dependency "highline"
  spec.add_dependency "rainbow"
  spec.add_dependency "slop", "~> 3.4"
  spec.add_dependency "specinfra", ">= 2.31.0"
  spec.add_dependency "unix-crypt"
end
