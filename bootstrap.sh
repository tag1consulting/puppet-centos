#!/bin/sh
#
# bootstrap.sh: preps our environment for puppet.

# Detect major version
OSVER=$(rpm -q --queryformat "%{VERSION}" centos-release)
echo "Bootstrapping CentOS $OSVER"

# Need git for r10k
rpm -q --quiet git || { echo "git package not found, installing with yum"; yum -y -q install git; }

# Need rubygems for r10k.
rpm -q --quiet rubygems || { echo "rubygems package not found, installing with yum"; yum -y -q install rubygems; }

# Install Puppet repos. Note: EPEL is installed by default on our CentOS images.
rpm -q --quiet puppetlabs-release-pc1 || { echo "puppetlabs-release-pc1 package not found, installing with rpm"; rpm -U --quiet http://yum.puppetlabs.com/puppetlabs-release-pc1-el-${OSVER}.noarch.rpm; }

# It helps to have puppet-agent installed...
rpm -q --quiet puppet-agent || { echo "puppet-agent package not found, installing with yum"; yum -y -q install puppet-agent; }

if [ "$OSVER" -eq "6" ]; then
  # We need ruby-devel in order to install the system_timer gem.
  rpm -q --quiet ruby-devel || { echo "ruby-devel package not found, installing with yum"; yum -y -q install ruby-devel; }
  # system_timer ruby gem is needed to avoid warnings on the CentOS 6 version of Ruby (1.8)
  [[ "$(gem query -i -n system_timer)" == "true" ]] || gem install --no-rdoc --no-ri system_timer
fi
