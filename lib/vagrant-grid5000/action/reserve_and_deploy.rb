require "log4r"
require 'time'

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
             walltime = format("%02d:%02d:%02d", walltime / (60*60), walltime / 60 % 60, walltime % 60)
          end
          if ENV['VAGRANT_DEBUG'] == 'REUSE_JOB'
						job = env[:g5k].get_my_jobs(cfg.site).first
          else
            job = env[:g5k].reserve(:site => cfg.site, :walltime => walltime,
                                          :properties => cfg.properties, :env => cfg.env, :keys => cfg.keys,
                                          :name => "vagrant-grid5000")
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
