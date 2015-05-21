# Plug-in
A serverkit plug-in is provided as a gem.
Serverkit calls `Bundler.require(:default)` before running an action,
so you can add any behaviors to serverkit via gems defined in Gemfile.
For example, [serverkit-rbenv](https://github.com/serverkit/serverkit-rbenv) gem
adds a custom resource type named `rbenv_ruby` by defining `Serverkit::Resources::RbenvRuby` class.
Serverkit finds `Serverkit::Resources::FooBar` resource class from `type: "foo_bar"`.

```rb
# Gemfile
gem "serverkit"
gem "serverkit-atom"
gem "serverkit-defaults"
gem "serverkit-homebrew"
gem "serverkit-karabiner"
gem "serverkit-rbenv"
gem "serverkit-login_items"
```
