# Serverkit [![Build Status](https://travis-ci.org/r7kamura/serverkit.svg)](https://travis-ci.org/r7kamura/serverkit) [![Code Climate](https://codeclimate.com/github/r7kamura/serverkit/badges/gpa.svg)](https://codeclimate.com/github/r7kamura/serverkit)
Configuration management toolkit for your infrastructure.

## Usage
```sh
# Write your recipe
vi recipe.yml

# Validate recipe
serverkit validate --recipe=recipe.yml

# Check differences
serverkit check --recipe=recipe.yml

# Apply migration
serverkit apply --recipe=recipe.yml
```

### Example
```yaml
# recipe.yml
resources:
  - name: install_mysql
    type: homebrew
    package: mysql
  - name: install_redis
    type: homebrew
    package: redis
  - name: install_licecap
    type: homebrew_cask
    package: licecap
  - name: install_alfred
    type: homebrew_cask
    package: alfred
  - name: clone_dotfiles
    type: git
    repository: git@github.com:r7kamura/dotfiles.git
    path: /Users/r7kamura/src/github.com/r7kamura/dotfiles
  - name: symlink_zshrc
    type: symlink
    source: /Users/r7kamura/.zshrc
    destination: /Users/r7kamura/src/github.com/r7kamura/dotfiles/linked/.zshrc
```
