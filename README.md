# Serverkit [![Build Status](https://travis-ci.org/r7kamura/serverkit.svg)](https://travis-ci.org/r7kamura/serverkit) [![Code Climate](https://codeclimate.com/github/r7kamura/serverkit/badges/gpa.svg)](https://codeclimate.com/github/r7kamura/serverkit)
Configuration management toolkit for IT automation.

- [Usage](#usage)
  - [serverkit validate](#serverkit-validate)
  - [serverkit inspect](#serverkit-inspect)
  - [serverkit check](#serverkit-check)
  - [serverkit apply](#serverkit-apply)
  - [SSH support](#ssh-support)
- [Recipe](#recipe)
  - [Format](#format)
  - [Variables](#variables)
  - [Example](#example)
- [Resource](#resource)
  - [Type](#type)
  - [Example](#example-1)
- [Handler](#handler)
- [Plug-in](#plug-in)
- [Vagrant](#vagrant)

## Usage
Write a recipe, then run `serverkit` executable to validate, inspect, check, and apply the recipe.

### serverkit validate
Validates recipe schema, resources, and attributes.
For instance, it shows validation error if `source` attributes is missing in `file` resource.

```
$ serverkit validate recipe.yml
Error: source attribute is required in file resource
Error: path attribute can't be unreadable path in recipe resource
```

### serverkit inspect
Shows fully-expanded recipe data in JSON format.

```
$ serverkit inspect recipe.yml
{
  "resources": [
    {
      "type": "homebrew",
      "name": "mysql"
    },
    {
      "type": "homebrew",
      "name": "redis"
    },
    {
      "type": "homebrew_cask",
      "name": "licecap"
    },
    {
      "type": "homebrew_cask",
      "name": "alfred"
    },
    {
      "type": "git",
      "repository": "git@github.com:r7kamura/dotfiles.git",
      "path": "/Users/r7kamura/src/github.com/r7kamura/dotfiles"
    },
    {
      "type": "symlink",
      "source": "/Users/r7kamura/.zshrc",
      "destination": "/Users/r7kamura/src/github.com/r7kamura/dotfiles/linked/.zshrc"
    }
  ]
}
```

### serverkit check
Shows the difference between your recipe and the state of the target host.

```
$ serverkit check recipe.yml
[ OK ] homebrew mysql on localhost
[ OK ] homebrew redis on localhost
[ OK ] homebrew_cask licecap on localhost
[ OK ] homebrew_cask alfred on localhost
[ NG ] git git@github.com:r7kamura/dotfiles.git on localhost
[ NG ] symlink /Users/r7kamura/src/github.com/r7kamura/dotfiles/linked/.zshrc on localhost
```

### serverkit apply
Executes migration process to fill-in the gaps.

```
$ serverkit apply recipe.yml
[SKIP] homebrew mysql on localhost
[SKIP] homebrew redis on localhost
[SKIP] homebrew_cask licecap on localhost
[SKIP] homebrew_cask alfred on localhost
[DONE] git git@github.com:r7kamura/dotfiles.git on localhost
[DONE] symlink /Users/r7kamura/src/github.com/r7kamura/dotfiles/linked/.zshrc on localhost
```

### SSH support
Use `--hosts=` option to execute serverkit over SSH.
Serverkit does not require any installation on server-side.
If you want to specify SSH configuration, write it into your ~/.ssh/config.

```
$ serverkit apply recipe.yml --hosts=alpha.example.com
$ serverkit apply recipe.yml --hosts=alpha.example.com,bravo.example.com
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

```
$ serverkit apply recipe
$ serverkit apply recipe.json
$ serverkit apply recipe.json.erb
$ serverkit apply recipe.json.erb --variables=variables
$ serverkit apply recipe.json.erb --variables=variables.json
$ serverkit apply recipe.json.erb --variables=variables.json.erb
$ serverkit apply recipe.json.erb --variables=variables.yml
$ serverkit apply recipe.json.erb --variables=variables.yml.erb
$ serverkit apply recipe.json.erb --variables=variables/
$ serverkit apply recipe.yml
$ serverkit apply recipe.yml.erb
$ serverkit apply recipes/
```

### Variables
When using ERB recipe, you can also give optional variables file
that defines configurations in a Hash object for ERB template.
It supports similar format variation with Recipe.
In ERB template, you can use given variables via methods named after its keys.

### Example
This is an example recipe to install some packages, clone a git repository, and create a symlink.

```yml
# variables.yml
dotfiles_repository: r7kamura/dotfiles
user: r7kamura
```

```yml
# recipe.yml.erb
resources:
  - type: package
    name: mysql
  - type: package
    name: redis
  - type: git
    repository: git@github.com:<%= dotfiles_repository %>.git
    path: /Users/<%= user %>/src/github.com/<%= dotfiles_repository %>
  - type: symlink
    source: /Users/<%= user %>/.zshrc
    destination: /Users/<%= user %>/src/github.com/<%= dotfiles_repository %>/.zshrc
```

## Resource
A resource is a statement of configuration policy that describes the desired state for an item.

### Type
A resource must have a type attribute. Currently the following types are available:

- command
- file
- git
- homebrew
- homebrew_cask
- nothing
- package
- recipe
- service
- symlink

### Example
An example package resource that has type and name attributes.

```yml
resources:
  - type: package
    name: mysql
```

## Handler
When any changes are successfully applied to a resource and it has notify attribute,
it notifies handlers that are referenced by their id.
The notified handlers will run only once after all resources finished their applications.
Here's an example of restarting Dock on Mac OS X when its preferences change.

```yml
resources:
  - type: defaults
    domain: com.apple.dock
    key: autohide
    value: 1
    notify:
      - restart_dock
  - type: defaults
    domain: com.apple.dock
    key: persistent-apps
    value: []
    notify:
      - restart_dock
handlers:
  - id: restart_dock
    type: command
    script: killall Dock
```

## Plug-in
A plug-in is provided as a gem.
Serverkit calls `Bundler.require(:default)` before running an action,
so you can add any behaviors to serverkit via gems defined in Gemfile.
For example, [serverkit-rbenv](https://github.com/r7kamura/serverkit-rbenv) gem
adds a custom resource type named `rbenv_ruby` by defining `Serverkit::Resources::RbenvRuby` class.
Serverkit finds `Serverkit::Resources::FooBar` resource class from `type: "foo_bar"`.

- [serverkit-defaults](https://github.com/r7kamura/serverkit-defaults)
- [serverkit-karabiner](https://github.com/r7kamura/serverkit-karabiner)
- [serverkit-rbenv](https://github.com/r7kamura/serverkit-rbenv)

```rb
# Gemfile
gem "serverkit"
gem "serverkit-defaults"
gem "serverkit-karabiner"
gem "serverkit-rbenv"
```

## Vagrant
[vagrant-serverkit](https://github.com/r7kamura/vagrant-serverkit)
helps you provision your vagrant box with serverkit.

```rb
# Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :serverkit do |serverkit_config|
    serverkit_config.recipe_path = "recipe.yml"
  end
end
```

```
$ vagrant plugin install vagrant-serverkit
$ vagrant up
```
