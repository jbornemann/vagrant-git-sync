module VagrantGitSyncModule
  module Core
    class Workspace

      require 'net/ping/tcp'

      attr_reader :unsupported_workspace

      def initialize(env)
        @env = env
        @vagrant_cwd = env[:env].cwd.to_s.strip.chomp('/')
        if system('git rev-parse 2> /dev/null > /dev/null')==true and Workspace.git_installed
          @unsupported_workspace = false
        else
          @unsupported_workspace = true
        end
      end

      #If an internet connection is not available, we want to bail out, and not get in the way
      def is_online?
        #Uses a SYN ping vs ICMP to avoid firewall issues.
        #Tries likely ports to determine if computer is up
        tls = Net::Ping::TCP.new(remote_repository, 443, 1)
        http = Net::Ping::TCP.new(remote_repository, 80, 1)
        ssh = Net::Ping::TCP.new(remote_repository, 22, 1)
        tls.ping or http.ping or ssh.ping
      end

      def update
        support_check
        Dir.chdir(@vagrant_cwd) do
          %x(git pull -X theirs -q)
        end
      end

      def index_clean?
        support_check
        Dir.chdir(@vagrant_cwd) do
          result = %x(git status -s).strip
          return result.empty?
        end
      end

      def is_master?
        support_check
        Dir.chdir(@vagrant_cwd) do
          result = %x(git rev-parse --abbrev-ref HEAD).strip
          return result == 'master'
        end
      end

      def self.git_installed
        not %x(which git).strip.empty?
      end

      private

      def support_check
        raise 'Unsupported workspace' if unsupported_workspace
      end

      def remote_repository
        result = ''
        Dir.chdir(@vagrant_cwd) do
          result = %x(git ls-remote --get-url).strip
        end
        parts = result.split('/')
        #Get rid of resource identifier
        just_url = parts.find do |part|
          part.include?('.')
        end
        #if SSH
        if just_url.include?('@')
          just_url = just_url.split('@')[1]
          #Take care of shorthand, and chop off :
          just_url = just_url.split(':')[0]
        end
        just_url
      end
    end
  end
end
