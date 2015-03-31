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
It is mostly a collection of resources, defined using certain patterns.

### Format
A recipe can be specified as a path to one of:

- JSON file
- YAML file named with \*.yaml or \*.yml
- Executable to output JSON
- Directory including recipe files recursively

```sh
serverkit apply --recipe=recipe.yml
serverkit apply --recipe=recipe.json
serverkit apply --recipe=recipe
serverkit apply --recipe=recipes/
```

### Example
This is an example recipe to install some packages,
clone a git repository, and create a symlink for a dotfile.

```yaml
# recipe.yml
resources:
  - id: install_mysql
    type: package
    package: mysql
  - id: install_redis
    type: package
    package: redis
  - id: clone_dotfiles
    type: git
    repository: git@github.com:r7kamura/dotfiles.git
    path: /Users/r7kamura/src/github.com/r7kamura/dotfiles
  - id: symlink_zshrc
    type: symlink
    source: /Users/r7kamura/.zshrc
    destination: /Users/r7kamura/src/github.com/r7kamura/dotfiles/linked/.zshrc
```
