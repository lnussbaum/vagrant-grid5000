require "log4r"

module VagrantPlugins
  module Grid5000
    module Action
      # This action connects to Grid'5000, verifies credentials work, and
      # puts the G5K connection object into the `:g5k` key in the environment.
      class ConnectGrid5000
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_grid5000::action::connect_grid5000")
        end

        def call(env)
          env[:g5k] = Cute::G5K::API.new(env[:machine].provider_config.cute_parameters || {})
          # FIXME customize logger to make it clear that ruby-cute is the one displaying messages
          raise "Unable to retrieve the list of sites and find nancy in it" if not env[:g5k].site_uids.include?('nancy')
          @app.call(env)
        end
      end
    end
  end
end
