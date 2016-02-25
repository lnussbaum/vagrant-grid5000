require "log4r"

$last_check_time = nil

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
          env[:g5k].logger = Logger.new(STDOUT)
          env[:g5k].logger.progname = 'ruby-cute'
          env[:g5k].logger.datetime_format = "%Y-%m-%d %H:%M:%S "
          if $last_check_time.nil? or $last_check_time + 60 < Time::now
            raise "Unable to retrieve the list of sites and find nancy in it" if not env[:g5k].site_uids.include?('nancy')
            $last_check_time = Time::now
          end
          @app.call(env)
        end
      end
    end
  end
end
