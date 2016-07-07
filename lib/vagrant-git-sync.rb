module VagrantGitSyncModule

  require 'core/plugin_action'
  require 'core/workspace'

  #We define our plugin here. '2' tells Vagrant that we would like to use Vagrant API version 2
  #See more here : https://www.vagrantup.com/docs/plugins/development-basics.html
  class Plugin < Vagrant.plugin('2')

    name 'vagrant-git-sync'

    description <<-DESC
      A Vagrant plugin that allows teams to automatically keep Git-backed environments in sync
    DESC

    #This is our 'in' into the Vagrant lifecycle. The ':environment_plugins_loaded' part is important
    #This symbol represents the earliest hook into Vagrant execution; before configuration is loaded
    #We want to run our plugin before configuration is loaded, because we are potentially loading
    #new configuration with this plugin.
    action_hook(:vagrant_git_sync, :environment_plugins_loaded) do |hook|
      hook.prepend(VagrantGitSyncModule::Core::PluginAction)
    end
  end
end
