# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    ### Define options for all VMs ###
    # Using vagrant-cachier improves performance if you run repeated yum/apt updates
    if defined? VagrantPlugins::Cachier
      config.cache.auto_detect = true
    end
    config.ssh.forward_agent = true

    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512", "--cpus", "4", "--ioapic", "on"]
    end

    config.vm.define :package_install do |node|
      node.vm.box = 'puppetlabs/debian-7.5-64-puppet'
      node.vm.hostname = 'debian7.boxnet'
      node.vm.network :private_network, :auto_network => true

    end

end
