require "log4r"
require 'time'
require 'fileutils'

VAGRANT_INSECURE_PUBLIC_KEY = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOF

module VagrantPlugins
  module Grid5000
    module Action
      class ReserveAndDeploy
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_grid5000::action::reserve_and_deploy")
        end

        def call(env)
          cfg = env[:machine].provider_config
          walltime = cfg.walltime
          if walltime.nil? # slightly broken: what if the local time doesn't switch DST at the same time as Europe/Paris?
             if Time::now.dst?
               target = '18:55:00 CEST'
             else
               target = '18:55:00 CET'
             end
             walltime = (Time::parse(target) - Time::now).to_i
             walltime += 86400 if walltime < 0 # if we are after the deadline, target the next day
             walltime = format("%02d:%02d:%02d", walltime / (60*60), walltime / 60 % 60, walltime % 60)
          end
          if ENV['VAGRANT_DEBUG'] == 'REUSE_JOB'
						job = env[:g5k].get_my_jobs(cfg.site).first
          else
						# hack: create a temporary file that holds the Vagrant public key, so that ruby-cute is happy.
						f = `mktemp /tmp/vagrant-grid5000-public-key.XXXXXX.pub`.chomp
						File::open(f, 'w') { |fd| fd.print VAGRANT_INSECURE_PUBLIC_KEY }
            job = env[:g5k].reserve(:site => cfg.site, :walltime => walltime,
                                    :properties => cfg.properties, :env => cfg.env, :keys => f.gsub('.pub', ''),
                                    :name => "vagrant-grid5000")
            FileUtils::rm(f)
          end
          env[:node] = job['assigned_nodes'].first
          env[:machine_state_id] = :running
          @logger.info("Node #{env[:node]} successfully started.")
          env[:job] = job
          env[:machine].id = "#{cfg.site}:#{job['uid']}:#{env[:node]}"
          @app.call(env)
        end
      end
    end
  end
end
