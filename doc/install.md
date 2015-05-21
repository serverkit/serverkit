# Install
## Prerequisites
Ruby 2.0.0 or later is required.

## via Bundler
We recommend you to use [bundler](http://bundler.io/) to install serverkit and its plugins,
and run serverkit via `bundle exec serverkit`.

```rb
# Gemfile
source "https://rubygems.org"
gem "serverkit"
```

```
$ gem install bundler
$ bundle install
```

## via Gem
Instead you can simply install serverkit by `gem` command,
while you cannot use plugins without bundler.

```
$ gem install serverkit
```

## via Source
If you want to install serverkit from source code for any reason,
you can `git clone` the source code and `rake install` it.
bundler and git are both required in this method.

```
$ git clone https://github.com/serverkit/serverkit.git
$ cd serverkit
$ bundle install
$ bundle exec rake install
```
