require "pathname"

require "vagrant-grid5000/plugin"

module VagrantPlugins
  module Grid5000
    lib_path = Pathname.new(File.expand_path("../vagrant-grid5000", __FILE__))
    autoload :Action, lib_path.join("action")
    autoload :Errors, lib_path.join("errors")

    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end
  end
end
