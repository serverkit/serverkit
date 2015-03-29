# Serverkit [![Build Status](https://travis-ci.org/r7kamura/serverkit.svg)](https://travis-ci.org/r7kamura/serverkit) [![Code Climate](https://codeclimate.com/github/r7kamura/serverkit/badges/gpa.svg)](https://codeclimate.com/github/r7kamura/serverkit)
Configuration management toolkit.

## Usage
```sh
# Create Gemfile
bundle init

# Install serverkit and its dependencies
echo 'gem "serverkit"' >> Gemfile
bundle install

# Write your recipe
vi recipe.yml

# Check
bundle exec serverkit check --recipe=recipe.yml

# Apply
bundle exec serverkit apply --recipe=recipe.yml
```
