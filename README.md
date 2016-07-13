# vagrant-git-sync
A Vagrant plugin that allows teams to automatically keep Git-backed environments in sync

Vagrant comes very close to eliminating the "it works on my machine" idiom.  One potential problem in practice is that this requires teams to explicitly keep local Git integration branch copies (containing Vagrant configuration) tightly in sync with their remote counterpart. It's an almost trivial detail, but easy to forget in wake of a largely otherwise automated environment. If the goal is to streamline local developer environments, this plugin can potentialy help in making your workflow leaner.   

We can eliminate this manual step by allowing Vagrant to reason about, and sync the integration branch in an automated fashion.

This requires some precaution that vagrant-git-sync manages for us:

- Is a feature branch being worked on (Are we off master)? Is the index dirty? If so, we probably don't want to update, and introduce surprises to the developer. vagrant-git-sync handles these cases automatically, and tries to not get in the way. Currently a feature branch is detected if the local branch is not "master".
- Do we have a stable internet connection? Can we reach the remote? vagrant-git-sync will try to bail out as early if it detects a less than steller connection. We don't want the plugin to introduce long pauses in workflow due to connectivity issues. 


vagrant-git-sync works by injecting middleware very early on in the Vagrant lifecycle. This allows us to update any Vagrant configuration (Vagrantfile, Puppet, Chef, etc) before configuration is actually loaded by Vagrant.  
