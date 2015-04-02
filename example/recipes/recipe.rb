#!/usr/bin/env ruby
require "json"
require "yaml"

puts YAML.load_file(File.expand_path("../recipe.yml", __FILE__)).to_json
