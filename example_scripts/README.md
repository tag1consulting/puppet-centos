Example / Helper Scripts
========================

```bootstrap_c7.sh``` -- This is a modified version of the default (EL6) version of the system bootstrap script, intended to install Puppet and any other dependencies for the Puppet to run initially. The main change between this and the EL6 version, is this installs the EL7 package for PuppetLabs

```run_puppet.sh``` -- This script is a wrapper around ```puppet apply```, and is useful when running this Puppet tree on a single host where you don't have a Puppet Master. To configure, edit ```PUPPET_WORKDIR``` to point to your local clone of this repo, you can then copy the script to e.g. /usr/local/bin.
