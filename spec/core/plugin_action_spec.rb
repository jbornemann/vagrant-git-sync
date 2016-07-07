require_relative '../../lib/core/plugin_action'

RSpec.describe VagrantGitSyncModule::Core::PluginAction do

  it 'we only update the workspace if the workspace is supported, is master, index is clean, and is online' do
    ui = double('Vagrant UI')
    expect(ui).to receive(:output)
    expect(ui).to receive(:success)
    env = instance_double('Vagrant::Environment', 'Vagrant Environment')
    expect(env).to receive(:ui).and_return(ui)
    env_map = {:env => env}
    workspace = instance_double('VagrantEnvModule::Core::Workspace', 'Vagrant Workspace')
    expect(VagrantGitSyncModule::Core::Workspace).to receive(:new).with(env_map).and_return(workspace)
    allow(workspace).to receive(:unsupported_workspace).and_return(false)
    allow(workspace).to receive(:is_master?).and_return(true)
    allow(workspace).to receive(:index_clean?).and_return(true)
    allow(workspace).to receive(:is_online?).and_return(true)

    expect(workspace).to receive(:update)

    plugin_action = VagrantGitSyncModule::Core::PluginAction.new(nil, nil)
    plugin_action.call(env_map)
  end
end
