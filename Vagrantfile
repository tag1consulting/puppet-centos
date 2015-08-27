# -*- mode: ruby -*-
# vi: set ft=ruby :

# You can override or add to this file by configuring the Vagrantfile.local
# Note the provided Vagrantfile.local.example

VAGRANTFILE_API_VERSION = "2"

# Require 1.6.2 since that's when the rsync synced folder was stabilized.
Vagrant.require_version ">= 1.6.2"

# Load zlib so port forwarding works.
require 'zlib'

project = File.basename(File.dirname(__FILE__));

dirname = File.dirname(__FILE__)
localfile = dirname + "/Vagrantfile.local"
default = dirname + "/scripts/Vagrantfile.default"
if File.exist?(localfile)
  load localfile
elsif File.exists?(default)
  load default
end

# Optional goodies like colorized output
extras = dirname + "/scripts/Vagrantfile.extras"
if File.exist?(extras)
  load extras
end

# Configure the domain
if !defined? $domainname
  $domainname = "tag1consulting.com"
end

Vagrant.configure('2') do |config|
  if defined? $box
    config.vm.box = $box
  else
    config.vm.box = "tag1/centos6-50GB-vbguest"
  end

  if defined? $box_url
    config.vm.box_url = $box_url
  else
    config.vm.box_url = "http://tag1consulting.com/files/centos6-50GB-vbguest.json"
  end

  #config.vm.box = "centos6.6-x86_64-50GB-disk-puppet-3.7.3-vbguestaddtions-20141212.box"
  #config.vm.box_url = "http://tag1consulting.com/files/centos6.6-x86_64-50GB-disk-puppet-3.7.3-vbguestaddtions-20141212.box"

  # Enable ssh agent forwarding
  config.ssh.forward_agent = true

  # You can define a $vms array in Vagrantfile.local which says what vms should be launched.
  if !defined? $vms
    $vms =   {
      "default" => { "fqdn" => "vagrant-test.tag1consulting.com", "ipaddress" => "10.10.10.10", "memory" => "2048", "cpus" => "2" },
    }
  end
  $vms.each do |name, attributes|
    config.vm.define "#{name}" do |name|
      # myvm.vm.provision "shell", inline: "echo hello from slave #{myname}"
      name.vm.network :private_network, ip: attributes["ipaddress"]
      name.vm.hostname = attributes['fqdn']
      $forwarded_port = attributes["forwarded_port"]
      unless $forwarded_port.nil? || $forwarded_port == 0
        # Generate unique port forward based on fqdn and directory
        portname = dirname + '/' + name.vm.hostname
        crc = Zlib::crc32(portname)
        $port_base = (crc % 500) * 100 + 3000
        if !defined? $port_base
          $port_base = 4000
        end
        $port = $port_base + $forwarded_port
        name.vm.network :forwarded_port, guest: $forwarded_port, host: $port, auto_correct: true
      end
      name.vm.hostname = attributes['fqdn']
      config.vm.provider "virtualbox" do |v|
        v.memory = attributes['memory']
        v.cpus = attributes['cpus']
        # Enable APIC, which is required for multiple CPU support under Virtualbox.
        v.customize ["modifyvm", :id, "--ioapic", "on"]
      end
    end
  end


  # Optional share for yum packages so that they don't have be downloaded all the time
  # when doing a clean build of different VMs.
  # To turn this on, set vagrant_yum_cache in your Vagrantfile.local,
  # $vagrant_yum_cache = "/var/cache/vagrantyum_cache"
  if defined? $vagrant_yum_cache
    config.vm.synced_folder $vagrant_yum_cache, "/var/cache/yum"
    config.vm.provision "shell",
      inline: "echo '--- Turning on yum caching in /etc/yum.conf ---'; perl -pi.bak -e 's/keepcache=0/keepcache=1/' /etc/yum.conf"
  end

  # Mount any development directories
  if defined? $dev_mounts
    # Default mount settings.

    $dev_mounts.each do |mount, attributes|
      # Handle mount options for various mount types.
      # Mounts can be defined in Vagrantfile.local.
      if attributes['type']=="virtualbox"
        config.vm.synced_folder attributes['host_mountpoint'], attributes['vm_mountpoint'], type: attributes['type'], owner: attributes['owner'], group: attributes['group'], mount_options: attributes['mount_options']
      elsif attributes['type']=="rsync"
          config.vm.synced_folder attributes['host_mountpoint'], attributes['vm_mountpoint'], type: attributes['type'], owner: attributes['owner'], group: attributes['group'], rsync__exclude: attributes['rsync__exclude'], rsync__chown: attributes['rsync__chown'], rsync__auto: attributes['rsync__auto']
      elsif attributes['type'] == 'nfs'
        config.vm.synced_folder attributes['host_mountpoint'], attributes['vm_mountpoint'], type: attributes['type']
      end
    end
  end


  # Install r10k using the shell provisioner and download the Puppet modules
  config.vm.provision "shell", path: 'bootstrap.sh'

  # Puppet provisioner for primary configuration
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = [ "modules", "site", "dist" ]
    puppet.manifest_file  = "site.pp"
    puppet.hiera_config_path = "hiera.yaml"
    puppet.working_directory = "/vagrant"
    puppet.options = ""

    # In vagrant environment it can be hard for facter to get this stuff right
    puppet.facter = {
      "dev_environment" => "vagrant",
      "domain" => $domainname,
    }
  end
  # Run post-puppet.sh
  config.vm.provision "shell", path: 'scripts/post-puppet.sh'

  if Vagrant.has_plugin?("vagrant-triggers")
    config.trigger.after [:up, :resume, :status, :restart, :reload] do
      $banner = "Build complete".green + " for ".clean + (project).to_s.bold.yellow
      $link = "http://localhost:" + $port.to_s + "/"
      puts
      info $banner
      unless $forwarded_port.nil? || $forwarded_port == 0
        $link = "http://localhost:" + $port.to_s + "/"
        info $link.underline
      end
      puts
    end
  end
end


# Determine if we are on windows
# http://happykoalas.com/blog/2012/04/vagrant-and-using-nfs-only-on-non-windows-host/
def Kernel.is_windows?
  # Detect if we are running on Windows
  processor, platform, *rest = RUBY_PLATFORM.split("-")
  platform == 'mingw32'
end
