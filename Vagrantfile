Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.plugin.add_dependency "vagrant-multiplug"
  config.plugin.add_dependency "vagrant-serverkit", "0.0.5"

  config.vm.provision(
    :serverkit,
    log_level: "DEBUG",
    recipe_path: "example/recipe.yml",
    variables_path: "example/variables.yml",
  )
end
