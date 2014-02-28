# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
DEVELOP_IP = "192.168.60.10"
VM_CPUS = 1
VM_RAM_MEGABYTES = 5012
BUILD_IMAGE=true
RUN_CONTAINER=true

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  ###################
  # Port Forwarding
  ###################
  config.vm.define "develop" do |develop|
    develop.vm.host_name = "develop"
    develop.vm.network "private_network", ip: DEVELOP_IP

    # foward riak server container http port to host machine
    develop.vm.network "forwarded_port", guest: 8098, host: 8098

    # foward riak server container protocol buffer port to host machine
    develop.vm.network "forwarded_port", guest: 8087, host: 8087
  end

  ###################
  # Docker Provisioning
  ###################
  config.vm.provision "docker" do |docker|
    "installs docker"
  end

  if BUILD_IMAGE
    config.vm.provision "shell", path: "scripts/build_image.sh"
  end

  if RUN_CONTAINER
    config.vm.provision "shell", path: "scripts/run_container.sh"
  end

  ###################
  # Virtualbox Provider
  ###################
  config.vm.provider :virtualbox do |vb, override|
    override.vm.box = "precise64_virtualbox"
    override.vm.box_url = "http://files.vagrantup.com/precise64.box"
    #override.vm.box = "saucy64_virtualbox"
    #override.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-1310-x64-virtualbox-puppet.box"

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", VM_RAM_MEGABYTES]
    vb.customize ["modifyvm", :id, "--cpus", VM_CPUS]
  end


  ###################
  # Vmware Fusion Provider
  ###################
  config.vm.provider :vmware_fusion do |v, override|
    # override box and box_url when using the "--provider vmware_fusion" flag
    override.vm.box = "precise64_fusion"
    override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"

    #override.vm.box = "saucy64_fusion"
    #override.vm.box_url = "http://shopify-vagrant.s3.amazonaws.com/ubuntu-13.10_vmware.box"
    v.gui = false
    v.vmx["memsize"] = VM_RAM_MEGABYTES
    v.vmx["numvcpus"] = VM_CPUS
  end

end
