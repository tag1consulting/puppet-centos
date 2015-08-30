We build two boxes for both EL6 and EL7:

* One box with the VirtualBox guest additions installed, as well as Puppet and all current CentOS updates.
* One box with all of the above installed, plus a "pre-run" of Puppet for a typical LAMP stack developer VM.

To build the box, use the scripts provided at https://github.com/jeffsheltren/vagrant-centos

For the box with Puppet run on it, after the install is complete and before exporting the box with Vagrant, boot the box within Virtualbox, clone this (puppet-centos) repo, run r10k to grab external modules, and then run example_scripts/run_puppet.sh  -- Then export as described in the vagrant-centos docs.

Currently the EL7 box requires some manual intervention to get the Virtualbox guest additions installed because that section of the kickstart errors out.
