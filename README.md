# Serverkit [![Build Status](https://travis-ci.org/r7kamura/serverkit.svg)](https://travis-ci.org/r7kamura/serverkit) [![Code Climate](https://codeclimate.com/github/r7kamura/serverkit/badges/gpa.svg)](https://codeclimate.com/github/r7kamura/serverkit)
Assemble servers from your recipe.

## Install
Serverkit is a gem, hosted on rubygems.org, and it requires Ruby 2.0.0 or higher.
We recommend you to use [bundler](http://bundler.io/)
to install serverkit and its plugins and dependencies.

```rb
# Gemfile
source "https://rubygems.org"
gem "serverkit"
```

```
$ gem install bundler
$ bundle install
```

Or you can simply install serverkit by `gem` command:

```
$ gem install serverkit
```

## Usage
Describe the desired state, then `serverkit apply`.

```yaml
# recipe.yml
resources:
  - type: package
    name: mysql
  - type: package
    name: redis
```

```
$ serverkit apply recipe.yml
```

## Documentation
- Actions
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
- [Vagrant integration](/doc/vagrant_integration.md)
