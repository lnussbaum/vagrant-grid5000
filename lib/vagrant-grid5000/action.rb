require "pathname"
require "cute"

require "vagrant/action/builder"

module VagrantPlugins
  module Grid5000
    module Action
      # Include the built-in modules so we can use them as top-level things.
      include Vagrant::Action::Builtin

      # TODO def self.action_halt

      # TODO def self.action_provision

      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use Call, DestroyConfirm do |env, b2|
            if env[:result]
              b2.use ConfigValidate
              b2.use Call, IsCreated do |env2, b3|
                if !env2[:result]
                  b3.use MessageNotCreated
                  next
                end
                b3.use ConnectGrid5000
                b3.use ReadState
                b3.use DestroyInstance
              end
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

      def self.action_ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end
            b2.use ConnectGrid5000
            b2.use ReadState
            b2.use SSHExec
          end
        end
      end

      def self.action_ssh_run
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end
            b2.use ConnectGrid5000
            b2.use ReadState
            b2.use SSHRun
          end
        end
      end

      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use HandleBox
          b.use ConfigValidate
          b.use BoxCheckOutdated
          b.use ConnectGrid5000
          b.use Call, IsCreated do |env1, b1|
            if env1[:result]
              b1.use MessageAlreadyCreated # TODO write a better message
            else
              b1.use ReserveAndDeploy
            end
          end
        end
      end

      # TODO def self.action_reload

      # The autoload farm
      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :ReserveAndDeploy, action_root.join("reserve_and_deploy")
      autoload :ReadState, action_root.join("read_state")
      autoload :ConnectGrid5000, action_root.join("connect_grid5000")
      autoload :DestroyInstance, action_root.join("destroy_instance")
      autoload :IsCreated, action_root.join("is_created")
      autoload :MessageAlreadyCreated, action_root.join("message_already_created")
    end
  end
end
