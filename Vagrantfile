# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Global parameters for the Grid'5000 provider
  config.vm.provider "grid5000" do |g5k|
    
    # Grid'5000 authentification parameters for Ruby-Cute
    # see http://www.rubydoc.info/github/ruby-cute/ruby-cute/master/Cute%2FG5K%2FAPI%3Ainitialize
    # default: use ~/.grid5000_api.yml
    #g5k.cute_parameters = { :username => 'jdoe', :password => 'foo' }
    
    # Site to reserve on (default: nancy)
    #g5k.site = rennes
    
    # OAR queue to use (default: default)
    #g5k.queue = 'default'

    # OAR properties to use (default: none)
    #g5k.properties = "cluster='griffon'"
    
    # Walltime (default: reserve until the next end of day (18:55))
    #g5k.walltime = '02:30'

    # Environment to deploy (default: jessie-x64-min)
    #g5k.env = 'jessie-x64-base'
  end

  config.vm.define :testbox do |tb|
    # All providers need to provide a box. This is a dummy, empty box for the grid5000 provider.
    tb.vm.box = "dummy"

    # VM-specific overrides
    tb.vm.provider 'grid5000' do |g5k|
      g5k.site = 'rennes'
      g5k.walltime = '0:15'
    end
  end

  config.vm.define :testbox2 do |tb2|
    tb2.vm.box = "dummy"

    # VM-specific overrides
    tb2.vm.provider 'grid5000' do |g5k|
      g5k.site = 'lyon'
      g5k.walltime = '0:15'
    end

    # Synced folders configuration, using rsync (you need to install it if you use -min or -base, see below)
    tb2.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"
  end

  # Since we connect as root directly, we don't need to set 'privileged' to true
  # However, it is a good idea to install sudo so that normal provisioning scripts
  # work.
  # rsync is needed for synced folders.
  config.vm.provision "shell", privileged: false, inline: 'apt-get update && apt-get -y install sudo rsync'

  # privileged: false is no longer required
  config.vm.provision "shell", inline: <<-SHELL
    #!/bin/bash -x
    apt-get -y install less vim ruby
    apt-get -y install git pv
  SHELL

end
