# Serverkit [![Build Status](https://travis-ci.org/r7kamura/serverkit.svg)](https://travis-ci.org/r7kamura/serverkit) [![Code Climate](https://codeclimate.com/github/r7kamura/serverkit/badges/gpa.svg)](https://codeclimate.com/github/r7kamura/serverkit)
Configuration management toolkit for your infrastructure.

## Usage
This gem provides `serverkit` executable with 3 actions.
`validate` action validates your recipe format.
`check` action shows the difference between your recipe and the state of the target host.
`apply` action executes migration programs to fill-in the gaps.

```sh
serverkit validate --recipe=recipe.yml
serverkit check --recipe=recipe.yml
serverkit apply --recipe=recipe.yml
```

## Recipe
A recipe is the most fundamental configuration which defines the desired state of your server.
It is mostly a collection of resources, defined using patterns (e.g. resource name, type, and other attributes).

### Format
JSON, YAML, and any executable that outputs JSON are supported as a recipe file.

```sh
serverkit apply --recipe=recipe.yml
serverkit apply --recipe=recipe.json
serverkit apply --recipe=recipe
```

### Example
This is an example recipe for Mac to install some packages of homebrew and homebrew-cask,
deploy a git repository, and create symlinks for dotfiles.

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
