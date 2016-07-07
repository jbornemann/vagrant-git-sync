# vagrant-git-sync
A Vagrant plugin that allows teams to automatically keep Git-backed environments in sync

Vagrant comes very close to eliminating the "it works on my machine" idiom.  One problem in practice can be that this requires team's to actively keep local Git Vagrant repositories tightly in sync. If this does not occur, then development environments can quickly diverge; bringing back the dreaded "It works on my machine."  

Since Vagrant promotes plug-n-play environments, we can eliminate this manual step by allowing Vagrant to reason about, and sync the Git workspace in an automated fashion.

This requires some precaution:

- Is a feature branch being worked on (Are we off master)? Is the index dirty? If so, we probably don't want to update, and introduce surprises to the developer. vagrant-git-sync handles these cases automatically, and tries to not get in the way. Currently a feature branch is detected if the local branch is not "master".
- Do we have an internet connection? Can we connect to the remote? vagrant-git-sync will try to bail out as early as possible if it detects this is the case. 


vagrant-git-sync injects middleware very early on in the Vagrant lifecycle. This allows us to update any Vagrant configuration (Vagrantfile, Puppet, Chef, etc) before configuration is actually loaded by Vagrant.  
