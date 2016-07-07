# vagrant-env
A Vagrant environment manager that allows teams to automatically keep environments in sync

Vagrant comes very close to eliminating the "it works on my machine" idiom.  One core issue, is that this requires a team's Vagrant workspace to be kept tightly in sync. If this does not occur, then development environments can quickly change independently of one another, and quickly regress to the original problem statement. 

Since Vagrant promotes plug-n-play environments, we can eliminate this gap by allowing Vagrant to reason about, and sync the workspace in an automated fashion.
