#!/bin/sh
#
# bootstrap.sh: preps our environment for puppet.

# Detect major version
OSVER=`rpm -q --queryformat "%{VERSION}" centos-release`
echo "Bootstrapping CentOS $OSVER"

# Need git for r10k
rpm -q --quiet git || { echo "git package not found, installing with yum"; yum -y -q install git; }

# Need rubygems for r10k.
rpm -q --quiet rubygems || { echo "rubygems package not found, installing with yum"; yum -y -q install rubygems; }

# Install Puppet repos. Note: EPEL is installed by default on Rackspace CentOS images.
rpm -q --quiet puppetlabs-release || { echo "puppetlabs-release package not found, installing with rpm"; rpm -Uvh http://yum.puppetlabs.com/puppetlabs-release-el-${OSVER}.noarch.rpm; }

# It helps to have puppet installed...
rpm -q --quiet puppet || { echo "puppet package not found, installing with yum"; yum -y -q install puppet; }

if [ "$OSVER" -eq "6" ]; then
  # We need rubygem-deep-merge for the 'deeper' merge setting used in Hiera.
  # This is provided in the puppetlabs-deps repo. We assume this repo is already
  # configured in the base box.
  rpm -q --quiet rubygem-deep-merge || { echo "rubygem-deep-merge package not found, installing with yum"; yum -y -q install rubygem-deep-merge; }

  # We need ruby-devel in order to install the system_timer gem.
  rpm -q --quiet ruby-devel || { echo "ruby-devel package not found, installing with yum"; yum -y -q install ruby-devel; }

  # system_timer ruby gem is needed to avoid warnings on the CentOS 6 version of Ruby (1.8)
  [[ "$(gem query -i -n system_timer)" == "true" ]] || gem install --no-rdoc --no-ri system_timer
else
  # We need rubygem-deep-merge for the 'deeper' merge setting used in Hiera.
  # This is provided in the puppetlabs-deps repo. We assume this repo is already
  # configured in the base box.
  rpm -q --quiet rubygem-deep_merge || { echo "rubygem-deep_merge package not found, installing with yum"; yum -y -q install rubygem-deep_merge; }
fi
