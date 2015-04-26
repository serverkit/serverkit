# Serverkit [![Build Status](https://travis-ci.org/r7kamura/serverkit.svg)](https://travis-ci.org/r7kamura/serverkit) [![Code Climate](https://codeclimate.com/github/r7kamura/serverkit/badges/gpa.svg)](https://codeclimate.com/github/r7kamura/serverkit)
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
 - [command](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/command.rb)
 - [directory](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/directory.rb)
 - [file](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/file.rb)
 - [git](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/git.rb)
 - [group](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/group.rb)
 - [line](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/line.rb)
 - [nothing](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/nothing.rb)
 - [package](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/package.rb)
 - [recipe](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/recipe.rb)
 - [remote_file](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/remote_file.rb)
 - [service](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/service.rb)
 - [symlink](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/symlink.rb)
 - [template](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/template.rb)
 - [user](https://github.com/r7kamura/serverkit/blob/master/lib/serverkit/resources/user.rb)
- [Plug-in](/doc/plug_in.md)
 - [serverkit-atom](https://github.com/r7kamura/serverkit-atom)
 - [serverkit-defaults](https://github.com/r7kamura/serverkit-defaults)
 - [serverkit-homebrew](https://github.com/r7kamura/serverkit-homebrew)
 - [serverkit-karabiner](https://github.com/r7kamura/serverkit-karabiner)
 - [serverkit-rbenv](https://github.com/r7kamura/serverkit-rbenv)
- [Vagrant integration](/doc/vagrant_integration.md)

## Similar tools
- [ansible/ansible](https://github.com/ansible/ansible)
- [fabric/fabric](https://github.com/fabric/fabric)
- [chef/chef](https://github.com/chef/chef)
- [puppetlabs/puppet](https://github.com/puppetlabs/puppet)
- [itamae-kitchen/itamae](https://github.com/itamae-kitchen/itamae)
