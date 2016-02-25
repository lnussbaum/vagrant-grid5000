require "pathname"
require "cute"

require "vagrant/action/builder"

module VagrantPlugins
  module Grid5000
    module Action
      # Include the built-in modules so we can use them as top-level things.
      include Vagrant::Action::Builtin

      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectGrid5000
          b.use ReserveAndDeploy
        end
      end

      def self.action_ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConnectGrid5000
          b.use ReadState
          b.use SSHExec
        end
      end

      def self.action_ssh_run
        return Vagrant::Action::Builder.new.tap do |b|
          b.use ConnectGrid5000
          b.use ReadState
          b.use SSHRun
        end
      end

      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConnectGrid5000
          b.use ReadState
          b.use Call, DestroyConfirm do |env, b2|
            if env[:result]
							b2.use DestroyInstance
            end
          end
        end
      end

      # This action is called to read the state of the machine. The
      # resulting state is expected to be put into the `:machine_state_id`
      # key.
      def self.action_read_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectGrid5000
          b.use ReadState
        end
      end

      # The autoload farm
      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :ReserveAndDeploy, action_root.join("reserve_and_deploy")
      autoload :ReadState, action_root.join("read_state")
      autoload :ConnectGrid5000, action_root.join("connect_grid5000")
      autoload :DestroyInstance, action_root.join("destroy_instance")
    end
  end
end
