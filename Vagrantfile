# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Global configuration for Grid'5000 access
  config.vm.provider "grid5000" do |g5k|
    # cute_parameters = { :conf_file =>"config file path" }

  end

  config.vm.define :my_g5k_box do |g5k|
    g5k.vm.box = "dummy"
  end
end
