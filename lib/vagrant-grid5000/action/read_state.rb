require "log4r"

module VagrantPlugins
  module Grid5000
    module Action
      # This action reads the state of the machine and puts it in the
      # `:machine_state_id` key in the environment.
      class ReadState
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_grid5000::action::read_state")
        end

        def call(env)
          env[:machine_state_id] = read_state(env)

          # Carry on
          @app.call(env)
        end

        $last_state_read = nil
        def read_state(env)
          
					return :not_created if not env[:g5k] or not env[:machine]
          id = env[:machine].id
          return :not_created if id.nil?
          site, jobid, node = id.split(':')

          if $last_state_read != nil and env[:job] and Time::now < $last_state_read + 60
            # skip
          else
						env[:job] = env[:g5k].get_job(site, jobid)
            $last_state_read = Time::now
          end
					env[:machine_ssh_info] = { :host => node, :port => 22, :username => 'root', :proxy_command => "ssh -W #{node}:22 #{env[:g5k].g5k_user}@access.grid5000.fr" }
          return :running if env[:job]['state'] == 'running'
          return :not_created
        end
      end
    end
  end
end
