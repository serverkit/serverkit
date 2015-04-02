# Serverkit [![Build Status](https://travis-ci.org/r7kamura/serverkit.svg)](https://travis-ci.org/r7kamura/serverkit) [![Code Climate](https://codeclimate.com/github/r7kamura/serverkit/badges/gpa.svg)](https://codeclimate.com/github/r7kamura/serverkit)
Configuration management toolkit for IT automation.

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
A recipe describes the desired state of your server.
It is mostly a collection of resources, defined using certain patterns.

### Format
A recipe can be specified as a path to one of the following patterns:

- JSON file
- YAML file named with \*.yaml or \*.yml
- ERB file named with \*.json.erb or \*.yml.erb
- Executable to output JSON
- Directory including recipe files recursively

```sh
serverkit apply --recipe=recipe
serverkit apply --recipe=recipe.json
serverkit apply --recipe=recipe.json.erb
serverkit apply --recipe=recipe.json.erb --variables=variables
serverkit apply --recipe=recipe.json.erb --variables=variables.json
serverkit apply --recipe=recipe.json.erb --variables=variables.json.erb
serverkit apply --recipe=recipe.json.erb --variables=variables.yml
serverkit apply --recipe=recipe.json.erb --variables=variables.yml.erb
serverkit apply --recipe=recipe.yml
serverkit apply --recipe=recipe.yml.erb
serverkit apply --recipe=recipes/
```

### Variables
When using ERB recipe, you can also give optional variables file
that defines configurations in a Hash object for ERB template.
It supports similar format variation with Recipe.
In ERB template, you can refer given variables via `variables` method.

### Example
This is an example recipe to install some packages, clone a git repository, and create a symlink.

```yaml
# variables.yml
dotfiles_repository: r7kamura/dotfiles
user: r7kamura
```

```yaml
# recipe.yml.erb
resources:
  - id: install_mysql
    type: package
    name: mysql
  - id: install_redis
    type: package
    name: redis
  - id: clone_dotfiles
    type: git
    repository: git@github.com:<%= variables["dotfiles_repository"] %>.git
    path: /Users/<%= variables["user"] %>/src/github.com/<%= variables["dotfiles_repository"] %>
  - id: symlink_zshrc
    type: symlink
    source: /Users/<%= variables["user"] %>/.zshrc
    destination: /Users/<%= variables["user"] %>/Dropbox/dotfiles/.zshrc
```

## Resource
A resource is a statement of configuration policy that describes the desired state for an item.

### Type
A resource must have a type property. Currently the following types are available:

- file
- git
- homebrew_cask
- homebrew
- package
- service
- symlink

### Example
An example package resource that has id, type, and name attributes.

```yaml
resources:
  - id: install_mysql # id attirbute (This resource is identified by this unique id)
    type: package     # type attribute (Serverkit::Resources::Package class is used for this)
    name: mysql       # name attribute (package resource requires name attribute)
```
