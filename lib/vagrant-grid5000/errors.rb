require "vagrant"

module VagrantPlugins
  module Grid5000
    module Errors
      class VagrantGrid5000Error < Vagrant::Errors::VagrantError
        error_namespace("vagrant_grid5000.errors")
      end
    end
  end
end
