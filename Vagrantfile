# -*- mode: ruby -*-
# vi: set ft=ruby :

# You can override or add to this file by configuring the Vagrantfile.local
# Note the provided Vagrantfile.local.example

VAGRANTFILE_API_VERSION = "2"

# Require 1.6.2 since that's when the rsync synced folder was stabilized.
Vagrant.require_version ">= 1.6.2"

# Update PATH to include Vagrant gems so that the r10k plugin can find puppet.
ENV["PATH"] = ENV["PATH"] + ":~/.vagrant.d/gems/bin"

# Load zlib so port forwarding works.
require 'zlib'

# We require puppet installed as a vagrant plugin for use with r10k.
begin
  gem "puppet"
rescue Gem::LoadError
  raise "Puppet must be installed as a vagrant plugin! Run 'vagrant plugin install puppet' to install."
end


project = File.basename(File.dirname(__FILE__));

dirname = File.dirname(__FILE__)
localfile = dirname + "/Vagrantfile.local"
if File.exist?(localfile)
  load localfile
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
  # Configure Virtualbox guest additions auto-update, defaults to enabled.
  if !defined? $vbguest_auto_update
    $vbguest_auto_update = true
  end
  config.vbguest.auto_update = $vbguest_auto_update

  # Temporary workaround for https://github.com/mitchellh/vagrant/issues/7610 (9/1/16)
  config.ssh.insert_key = false

  if defined? $box
    config.vm.box = $box
  else
    config.vm.box = "centos/7"
  end

  # Enable ssh agent forwarding
  config.ssh.forward_agent = true

  # You can define a $vms array in Vagrantfile.local which says what vms should be launched.
  if !defined? $vms
    $vms =   {
      "default" => { "fqdn" => "vagrant-multi1.tag1consulting.com", "ipaddress" => "10.10.10.10", "memory" => "2048", "cpus" => "2" },
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

  # Run r10k before running puppet.
  config.r10k.puppet_dir = "code/environments/production"
  config.r10k.puppetfile_path = "Puppetfile"
  config.r10k.module_path = "code/environments/production/modules"

  if !defined? $puppet_options
    $puppet_options = " --log_level warning"
  end

  # Puppet provisioner for primary configuration
  config.vm.provision "puppet" do |puppet|
    puppet.environment = "production"
    puppet.environment_path = "code/environments"
    puppet.hiera_config_path = "code/environments/production/hiera.yaml"
    puppet.options = $puppet_options

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
