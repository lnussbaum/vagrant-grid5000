require "vagrant"

module VagrantPlugins
  module Grid5000
    class Config < Vagrant.plugin("2", :config)
      
      # This Vagrant plugin uses the Ruby-Cute library to interact with Grid'5000.
      # This gives, as a hash, the parameters to pass to Ruby-Cute's initialization.
      # For valid values, see: 
      # http://www.rubydoc.info/github/ruby-cute/ruby-cute/master/Cute%2FG5K%2FAPI%3Ainitialize
      #
      # @return [String]
      attr_accessor :cute_parameters

      # Site to reserve resources on. (default: nancy)
      # @return [String]
      attr_accessor :site
 
      # OAR properties to use when reserving resources. (default: empty ; example: cluster='graphene')
      # @return [String]
      attr_accessor :properties

      # Walltime to use when reserving resources. (default: reserve resources until today at 6:55pm)
      # @return [String]
      attr_accessor :walltime

      # The Grid'5000 environment to deploy (default: jessie-x64-min)
      # An URL to a dsc can be specified instead.
      # @return [String]
      attr_accessor :env

      def initialize()
        @cute_parameters = UNSET_VALUE
        @env = UNSET_VALUE
        @site = UNSET_VALUE
        @properties = UNSET_VALUE
        @walltime = UNSET_VALUE
      end

      def finalize!
        @cute_parameters = nil if @cute_parameters == UNSET_VALUE
        @site = 'nancy' if @site == UNSET_VALUE
        @env = 'jessie-x64-min' if @env == UNSET_VALUE
        @properties = '' if @properties == UNSET_VALUE
        @walltime = nil if @walltime == UNSET_VALUE
      end

      def validate(machine)
        errors = _detected_errors
#        errors << I18n.t("vagrant_grid5000.config.server_required") if @server.nil?
        { "Grid5000 Provider" => errors }
      end
    end
  end
end
