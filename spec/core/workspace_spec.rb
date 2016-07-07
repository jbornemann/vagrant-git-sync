require_relative '../../lib/core/workspace'

module Kernel

  def self.system_expected_result(function)
    @@function = function
  end

  define_method(:'`') do |args|
    @@function[args]
  end
end

RSpec.describe VagrantGitSyncModule::Core::Workspace do

  context 'Constructing the workspace correctly' do

   [
       {:which_git => ''            , :is_git_repo => true, :unsupported => true},
       {:which_git => '/usr/bin/git', :is_git_repo => false,:unsupported => true},
       {:which_git => '/usr/bin/git', :is_git_repo => true, :unsupported => false}
   ].each do |variant|
     it "Only supports Git workspaces. #{variant}" do
       Kernel.system_expected_result({'which git' => variant[:which_git]})
       env = instance_double('Vagrant::Environment')
       #Make sure we clean up dangling whitespace, or trailing slash in case env is coming from user (like env variable)
       allow(env).to receive(:cwd).and_return('/test/vagrant/ ')
       env_map = {:env => env}
       allow(File).to receive(:exist?).with('/test/vagrant/.git').and_return(variant[:is_git_repo])

       workspace = VagrantGitSyncModule::Core::Workspace.new(env_map)

       expect(workspace.unsupported_workspace).to be variant[:unsupported]
     end
   end
  end

  def with_workspace
    Kernel.system_expected_result({'which git' => '/usr/bin/git'})
    env = instance_double('Vagrant::Environment')
    allow(env).to receive(:cwd).and_return('/test/vagrant')
    env_map = {:env => env}
    allow(File).to receive(:exist?).with('/test/vagrant/.git').and_return(true)
    workspace = VagrantGitSyncModule::Core::Workspace.new(env_map)
    yield workspace
  end

  [
      {:https => true, :http => false, :ssh => false, :url => 'https://example.com/gitproject.git'},
      {:https => true, :http => false, :ssh => false, :url => 'git://example.com/gitproject.git'},
      {:https => true, :http => false, :ssh => false, :url => 'git@example.com/gitproject.git'},
      {:https => false,:http => true,  :ssh => false, :url => 'http://example.com/gitproject.git'},
      {:https => false,:http => false, :ssh => true,  :url => 'ssh://user@example.com/project.git'},
      {:https => false,:http => false, :ssh => true,  :url => 'user@example.com:project.git'},
      {:https => false,:http => false, :ssh => false, :url => 'user@example.com:project.git'},
  ].each do |variant|
    it "Determine if workspace remote is up : #{variant}" do
      with_workspace do |workspace|
        Kernel.system_expected_result({'git ls-remote --get-url' => variant[:url]})
        allow(Dir).to receive(:chdir).and_yield
        https = instance_double('Net::Ping::TCP', 'https_ping')
        allow(https).to receive(:ping).and_return(variant[:https])
        http = instance_double('Net::Ping::TCP', 'http_ping')
        allow(http).to receive(:ping).and_return(variant[:http])
        ssh = instance_double('Net::Ping::TCP', 'ssh_ping')
        allow(ssh).to receive(:ping).and_return(variant[:ssh])
        expect(Net::Ping::TCP).to receive(:new).with('example.com', 443, 1).and_return(https)
        expect(Net::Ping::TCP).to receive(:new).with('example.com', 80, 1).and_return(http)
        expect(Net::Ping::TCP).to receive(:new).with('example.com', 22, 1).and_return(ssh)

        expect(workspace.is_online?).to be (variant[:https] or variant[:http] or variant[:ssh])
      end
    end
  end

  [
      {:git_status => '',                              :index_clean => true},
      {:git_status => 'M spec/core/workspace_spec.rb', :index_clean => false}
  ].each do |variant|
    it "index_clean? : #{variant}" do
      with_workspace do |workspace|
        Kernel.system_expected_result({'git status -s' => variant[:git_status]})
        expect(Dir).to receive(:chdir).and_yield
        expect(workspace.index_clean?).to be variant[:index_clean]
      end
    end
  end

  [
      {:branch => 'master',  :is_master => true},
      {:branch => 'feature', :is_master => false}
  ].each do |variant|
    it "is_master? : #{variant}" do
      with_workspace do |workspace|
        Kernel.system_expected_result({'git rev-parse --abbrev-ref HEAD' => variant[:branch]})
        expect(Dir).to receive(:chdir).and_yield
        expect(workspace.is_master?).to be variant[:is_master]
      end
    end
  end
end
