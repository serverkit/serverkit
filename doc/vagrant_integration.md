# Vagrant integration
If you want to use serverkit with [Vagrant](https://www.vagrantup.com/),
there are 2 options to do it.

## --hosts=
One is to use pass the machine's host name via `--hosts=` option like below.
Note that `vagrant ssh-config` command outputs SSH configuration for the machine on vagrant
with `Host default`, and serverkit will use it by `--hosts=default` option.

```
$ vagrant ssh-config >> ~/.ssh/config
$ serverkit apply recipe.yml --hosts=default
```

## vagrant-serverkit
There is a 3rd party vagrant plugin called
[vagrant-serverkit](https://github.com/r7kamura/vagrant-serverkit).
It helps you provision your vagrant box with using serverkit.

```rb
# Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision(
    :serverkit,
    recipe_path: "recipe.yml",
  )
end
```

```
$ vagrant plugin install vagrant-serverkit
$ vagrant up
```
