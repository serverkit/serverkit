# frozen_string_literal: true

require "serverkit"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end

# Dirty configuration to silent useless warnings from specinfra.
require "specinfra"
Specinfra.configuration.backend = :exec
