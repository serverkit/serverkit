Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.plugin.add_dependency "vagrant-multiplug"
  config.plugin.add_dependency "vagrant-serverkit", "0.0.5"

  config.vm.provision :serverkit do |serverkit_config|
    serverkit_config.log_level = "DEBUG"
    serverkit_config.recipe_path = "example/recipes/recipe.yml"
    serverkit_config.variables_path = "example/variables"
  end
end
