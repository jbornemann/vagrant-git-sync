module VagrantGitSyncModule
  module Core

    #This class represents our execution within the Vagrant lifecycle. Vagrant will initialize us with a bunch of
    #initial application, and environment state we don't care about; then it will call us with a reference to the
    #current environment context.
    class PluginAction

      def initialize(app, env)
      end

      #Vagrant will call this function when our plugin middleware is ready to execute
      #env {Vagrant::Environment} : the current environment context. We can access the UI, and other info from this
      def call(env)
        workspace = VagrantGitSyncModule::Core::Workspace.new(env)
        ui = env[:env].ui
        if workspace.unsupported_workspace
          ui.error 'vagrant-git-sync plugin has detected an unsupported workspace in Vagrant working directory. Make sure you have Git installed, with Git managing your Vagrant workspace'
          return
        end
        ui.output 'Checking environment..'
        unless workspace.is_master?
          ui.warn 'Not on master. Not updating this time..'
          return
        end
        unless workspace.index_clean?
          ui.warn 'You are on master, but your index is not clean. Not updating this time..'
          return
        end
        unless workspace.is_online?
          ui.warn 'Offline. Not updating this time..'
          return
        end
        workspace.update
        ui.success 'Environment up to date'
      end
    end
  end
end
