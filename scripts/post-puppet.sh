#!/bin/sh

# This script will be run after Puppet on a Vagrant provision.

# Cleanup old drush install from vagrant home directory.
/vagrant/scripts/drush8-cleanup.sh
