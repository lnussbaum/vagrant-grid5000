module VagrantPlugins
  module Grid5000
    module Action
      class MessageAlreadyCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info('Machine already created.')
          @app.call(env)
        end
      end
    end
  end
end
