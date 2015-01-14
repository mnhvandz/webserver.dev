# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty32"
  config.vm.hostname = "webserver.dev"

  # Static IP address
  config.vm.network "public_network", ip: "192.168.2.10"
  
  # Assemption, one machine per project
  config.vm.synced_folder "./project/html", "/var/www/html", id: "vagrant-root", :owner => "vagrant", :group => "www-data", create: true, :mount_options => ['dmode=775', 'fmode=775']

  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end

  # Shell commands to execute within the guest virtual machine
  config.vm.provision :shell, path: "shell_provisioning/shell_provisioning.sh"
end
