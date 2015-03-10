#!/bin/sh

##
# bootstrap.sh: preps our environment for puppet.
# Installs r10k, puppet, hiera, and their dependencies.
# This script assumes a CentOS 6.x host.

# Need git for r10k
rpm -q --quiet git || yum -y install git

# Need rubygems for r10k.
rpm -q --quiet rubygems || yum -y install rubygems

# Install Puppet repos. Note: EPEL is installed by default on Rackspace CentOS images.
rpm -q --quiet puppetlabs-release || rpm -Uvh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

# It helps to have puppet installed...
rpm -q --quiet puppet || yum -y install puppet

# We need rubygem-deep-merge for the 'deeper' merge setting used in Hiera.
# This is provided in the puppetlabs-deps repo. We assume this repo is already
# configured in the base box.
rpm -q --quiet rubygem-deep-merge || yum -y install rubygem-deep-merge

# We need ruby-devel in order to install the system_timer gem.
rpm -q --quiet ruby-devel || yum -y install ruby-devel

# Install r10k to handle Puppet module installation.
[[ "$(gem query -i -n r10k)" == "true" ]] || gem install --no-rdoc --no-ri r10k

# system_timer ruby gem is needed to avoid warnings on the CentOS 6 version of Ruby (1.8)
[[ "$(gem query -i -n system_timer)" == "true" ]] || gem install --no-rdoc --no-ri system_timer

# Run r10k to pull in external modules.
cd /vagrant && r10k -v info puppetfile install

# The following is only required on Rackspace.
# Rackspace Vagrant plugin seems to run puppet with /tmp module paths no matter what we configure.
# And the number in the directory /tmp/vagrant-puppet-# seems to change occasionally -- and is not well
# documented in Vagrant or the Rackspace plugin.
# This is a hacky workaround just to get things working without too much effort.
#rm -fr /tmp/vagrant-puppet-2/modules-0 && ln -s /vagrant/modules /tmp/vagrant-puppet-2/modules-0
