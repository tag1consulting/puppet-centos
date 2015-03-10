#!/bin/bash

# Script to run 'puppet apply' on a local clone of the Puppet scripts git repo.
# The working directory configuration is required because we use
# relative paths in the hiera configuration.

# Set this to your local puppet git clone.
PUPPET_WORKDIR=/srv/puppet

cd $PUPPET_WORKDIR && puppet apply --modulepath=modules:site:dist --hiera_config=hiera.yaml manifests/site.pp
