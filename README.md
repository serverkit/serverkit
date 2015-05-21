# Serverkit [![Build Status](https://travis-ci.org/serverkit/serverkit.svg)](https://travis-ci.org/serverkit/serverkit) [![Code Climate](https://codeclimate.com/github/serverkit/serverkit/badges/gpa.svg)](https://codeclimate.com/github/serverkit/serverkit)
Assemble servers from your recipe.

![Server (thx 1041uuu)](/images/server.png)

## Usage
Describe the desired state, then `serverkit apply`.

```sh
$ echo '
resources:
  - type: package
    name: mysql
  - type: package
    name: redis
' > recipe.yml
$ serverkit apply recipe.yml
```

## Documentation
- [Install](/doc/install.md)
- [serverkit apply](/doc/action_apply.md)
- [serverkit check](/doc/action_check.md)
- [serverkit inspect](/doc/action_inspect.md)
- [serverkit validate](/doc/action_validate.md)
- [Recipe](/doc/recipe.md)
- [Resource](/doc/resource.md)
 - [command](/doc/resource_command.md)
 - [directory](/doc/resource_directory.md)
 - [file](/doc/resource_file.md)
 - [git](/doc/resource_git.md)
 - [group](/doc/resource_group.md)
 - [line](/doc/resource_line.md)
 - [nothing](/doc/resource_nothing.md)
 - [package](/doc/resource_package.md)
 - [recipe](/doc/resource_recipe.md)
 - [remote_file](/doc/resource_remote_file.md)
 - [service](/doc/resource_service.md)
 - [symlink](/doc/resource_symlink.md)
 - [template](/doc/resource_template.md)
 - [user](/doc/resource_user.md)
- [Plug-in](/doc/plug_in.md)
 - [serverkit-atom](https://github.com/serverkit/serverkit-atom)
 - [serverkit-defaults](https://github.com/serverkit/serverkit-defaults)
 - [serverkit-homebrew](https://github.com/serverkit/serverkit-homebrew)
 - [serverkit-karabiner](https://github.com/serverkit/serverkit-karabiner)
 - [serverkit-rbenv](https://github.com/serverkit/serverkit-rbenv)
 - [serverkit-login_items](https://github.com/take/serverkit-login_items)
- [Vagrant integration](/doc/vagrant_integration.md)

## Similar tools
- [ansible/ansible](https://github.com/ansible/ansible)
- [fabric/fabric](https://github.com/fabric/fabric)
- [chef/chef](https://github.com/chef/chef)
- [puppetlabs/puppet](https://github.com/puppetlabs/puppet)
- [itamae-kitchen/itamae](https://github.com/itamae-kitchen/itamae)
