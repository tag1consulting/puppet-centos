Example Puppet Configuration For EL6 and EL7
============================================
This repo contains Puppet and Vagrant scripts, providing an example of how to use Puppet and Hiera with external modules, keeping specific configuration information within Hiera so that the modules themselves remain portable and re-usable.

If you are just getting started with Puppet and/or Hiera, this can provide a good learning experience, or be used as a starting point for your own Puppet tree.  Additionally, with very little work, this can be used to provide Vagrant-based development VMs.

We rely on external "Forge" modules as much as possible, and use r10k (https://github.com/adrienthebo/r10k) to pull them in from external repos as needed.

```site/``` (site-specific modules) and ```dist/``` (generic modules that could be exported elsewhere)  directories contain locally developed modules. The ```modules/``` directory is automatically populated by r10k and nothing in there should be edited directly.

General notes
-------------
For the local install, we are using a CentOS Vagrant box (image) built internally. You could also get this working with your own EL6-based image, or using the images provided by Puppet Labs (http://puppet-vagrant-boxes.puppetlabs.com/).

Puppet modules are pulled in using r10k on the VM. If this is confusing/problematic for your setup, an alternative would be to manually populate the ```modules/``` directory (using r10k, or downloading by hand), and remove that directory from ```.gitignore```. However, you should never edit those external modules directly -- and our approach ensures that won't happen.

Whether running these puppet scripts as a Vagrant VM, or for a number of hosts connecting to a puppetmaster, it's likely your host(s) will need some sort of bootstrap to be ready to run puppet. ```bootstrap.sh``` is intended for that purpose, though it may need customization depending on the system image you're starting with. This script performs pre-puppet tasks like installing Puppet and r10k.

Hiera
-----
Hiera allows you to separate out configuration information from the logic in Puppet module classes. In addition, it provides a configurable hierarchy for the configuration information such that you can define common configuration data to be used across all hosts, and then override that with configuration for more specific host groups or individual hosts. There are many ways to configure Hiera, and depending on your environment you may require additional (or fewer!) hiera groupings.

Our example Hiera hierarchy includes groupings named ```hostenv``` and ```hosttype```. These are dynamic variables set in ```manifests/site.pp``` based on a hosts FQDN. We assume a hostname of the form ```<hostenv>-<hosttype><unique number>.example.com```, for example: ```prod-web1.example.com```. Typically we limit the host environment to one of "prod", "stage", or "dev", however any names could be used there. The host type is to define the role of a host, such as "db", "web", "app", or ”util". Additionally, for multi-role hosts (e.g. dev VMs), a host type of "multi" could be used.

See ```hiera.yaml``` for the hierarchy definition and precedence. and ``hiera/hosts/vagrant-test.tag1consulting.dev.yaml.example``` for some examples of overriding Hiera defaults for a specific VM host without having to edit common.yaml.

Additionally, Hiera has been configured here to use two backends: JSON and YAML. This allows us to separate private infrastructure information (e.g. passwords) into a separate git repo. This way, developers can have access to the Puppet repo to be able to spin up Dev VMs, but won't have access to private system information. We chose to use JSON for the private repo (which should be the higher-precedence backend) simply because we find YAML more friendly to read and edit — so we keep JSON for the limited number of things kept private.

Private Hiera Data
------------------
To store private Hiera data (e.g. MySQL passwords, user password hashes), we recommend creating a separate "hiera_private" repo, and symlink to that directory from the root of this Puppet tree. ```hiera.yaml``` is configured to look for a JSON-formatted Hiera directory at ```hiera_private```.

Running on a Stand-alone Server
-------------------------------
Puppet can be run manually on a stand-alone server using the ```puppet apply``` command.  We provide an example wrapper script, ```run_puppet.sh``` which sets the appropriate working directory and module/hiera configuration arguments.

Local install using VirtualBox
------------------------------
 * Install VirtualBox
 * Install Vagrant
 * Install required Vagrant plugins:
   * `vagrant plugin install vagrant-vbguest`
   * `vagrant plugin install puppet`
   * `vagrant plugin install vagrant-r10k`
 * Checkout this repo
 * Create a modules directory: ```mkdir modules```
 * If you want to adjust Vagrant/Virtualbox settings such as memory allocation, CPU allocation, or shared mounts, copy ```Vagrantfile.local.example``` to ```Vagrantfile.local``` and make your changes there.
 * Most modifications to the VM setup (PHP version, Apache vhosts, sudo settings, MySQL settings, etc.) are configurable in Hiera. See ```vagrant-test.tag1consulting.dev.yaml.example``` for examples.
 * Making Hiera changes in custom files (hostname-based, hosttype-based, etc.) will help prevent merge conflicts if you pull changes from this repo later.
 * Run: ```vagrant up --provider=virtualbox```

Running on a Rackspace VM
-------------------------
It's possible to run this setup on a remote Rackspace VM by using the vagrant-rackspace plugin. In order to use Rackspace as a provider:
 * Install vagrant-rackspace plugin
 * Copy ```example_scripts/rackspace_provisioner/Vagrantfile``` into this root directory of the git repo.
 * Copy ```example_scripts/rackspace_provisioner/Vagrantfile.local.example``` to ```Vagrantfile.local.```
 * Edit ```Vagrantfile.local``` with your ssh key, rackspace credentials, etc.
 * Edit ```bootstrap.sh``` to un-comment the line which fixes the puppet modules directory on Rackspace.
 * Run: ```vagrant up --provider=rackspace```

Note: Beware leaving the VM running or you may have a large Rackspace bill! You can ```vagrant destroy``` or manually delete it through the RS Cloud control panel.

History
-------
[Tag1 Consulting](http://tag1consulting.com) created these scripts with support from [Webwise Solutions](http://webwiseone.com). The goal is to provide an example Puppet tree, utilizing Hiera and external modules as much as possible, to have a quick starting point for creating a larger Puppet tree, or for those looking to create easily customizable dev VMs.
