# Recipe
A recipe describes the desired state of your server.
It is mostly a collection of resources, defined using certain patterns.

## Format
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

## Variables
When using ERB recipe, you can also give optional variables file via `--variables=` option
that defines configurations in a Hash object for ERB template.
It supports similar format variation with Recipe.
In ERB template, you can use given variables via methods named after its keys.

## Handler
When any changes are successfully applied to a resource and it has notify attribute,
it notifies handlers that are referenced by their id.
The notified handlers will run only once after all resources finished their applications.
Here's an example of restarting Dock on Mac OS X when its preferences change.

## Example
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
  - type: defaults
    domain: com.apple.dock
    key: autohide
    value: 1
    notify:
      - restart_dock
handlers:
  - id: restart_dock
    type: command
    script: killall Dock
```

```
$ serverkit apply recipe.yml.erb --variables=variables.yml
```
