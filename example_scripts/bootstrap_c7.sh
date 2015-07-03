#!/bin/sh

##
# bootstrap.sh: preps our environment for puppet.
# Installs r10k, puppet, hiera, and their dependencies.
# This script assumes a CentOS 7.x host.

# Need git for r10k
rpm -q --quiet git || { echo "git package not found, installing with yum"; yum -y install git; }

# Need rubygems for r10k.
rpm -q --quiet rubygems || { echo "rubygems package not found, installing with yum"; yum -y install rubygems; }

# Install Puppet repos. Note: EPEL is installed by default on Rackspace CentOS images.
rpm -q --quiet puppetlabs-release || { echo "puppetlabs-release package not found, installing with rpm"; rpm -Uvh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm; }

# It helps to have puppet installed...
rpm -q --quiet puppet || { echo "puppet package not found, installing with yum"; yum -y install puppet; }

# We need rubygem-deep-merge for the 'deeper' merge setting used in Hiera.
# This is provided in the puppetlabs-deps repo (installed above).
rpm -q --quiet rubygem-deep_merge || { echo "rubygem-deep_merge package not found, installing with yum"; yum -y install rubygem-deep_merge; }

# Install r10k to handle Puppet module installation.
[[ "$(gem query -i -n r10k)" == "true" ]] || { echo "r10k gem not found, installing with gem"; gem install --no-rdoc --no-ri r10k; }

# Run r10k to pull in external modules.
cd /vagrant && /usr/local/bin/r10k -v info puppetfile install
