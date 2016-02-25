# Vagrant Grid5000 Provider

<span class="badges">
[![Gem Version](https://badge.fury.io/rb/vagrant-grid5000.png)][gem]
</span>

[gem]: https://rubygems.org/gems/vagrant-grid5000

This is a [Vagrant](http://www.vagrantup.com) plugin that adds a provider for
machines running on the [Grid'5000](https://www.grid5000.fr) testbed to
Vagrant.

This is still at an early state of development.

## What works
* vagrant up --provider=grid5000
* vagrant status
* vagrant ssh
* vagrant destroy

## What doesn't work

* everything else

## Installation

```
$ vagrant plugin install vagrant-grid5000
```

Each provider needs at least one ''box''. This does not really make sense here, so we are providing a dummy one.
```
$ vagrant box add --name dummy https://github.com/lnussbaum/vagrant-grid5000/raw/master/dummy.box
```

Example Vagrantfile:
```ruby
Vagrant.configure("2") do |config|

  # Global configuration for Grid'5000 access
  config.vm.provider "grid5000" do |g5k|
    # cute_parameters = { :conf_file =>"config file path" }
    # For details about allowed parameters see
    # https://github.com/lnussbaum/vagrant-grid5000/blob/master/lib/vagrant-grid5000/config.rb

  end

  config.vm.define :my_g5k_box do |g5k|
    g5k.vm.box = "dummy"
  end
end
```

## License

The gem is available as free software under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Development

To work on the `vagrant-grid5000` plugin, clone this repository out, and use
[Bundler](http://gembundler.com) to get the dependencies:

```
$ bundle
```

You can test the plugin without installing it into your Vagrant environment by
using the `Vagrantfile` in the top level of this directory and use bundler to
execute Vagrant.
```
$ bundle exec vagrant up --provider=grid5000
```
etc.
