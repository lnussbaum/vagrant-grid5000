require "log4r"
require 'time'

module VagrantPlugins
  module Grid5000
    module Action
      class DestroyInstance
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_grid5000::action::destroy_instance")
        end

        def call(env)
          env[:g5k].release(env[:job])
          env[:machine_state_id] = :destroyed
          env[:machine].id = nil
          @app.call(env)
        end
      end
    end
  end
end
