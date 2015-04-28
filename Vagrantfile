# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

if !File.exists?('./sqlserver.iso')
  puts 'SQL Server installer could not be found!'
  puts "Please place sqlserver.iso in this directory."
  exit 1
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "opentable/win-2012r2-standard-amd64-nocm"
  config.vm.network "private_network", ip: "192.168.50.4"
  config.vm.network :forwarded_port, guest: 3389, host: 33389, id: "rdp", auto_correct: true

  config.vm.provision :install_dot_net, type: "shell", path: "scripts/install-dot-net.ps1"
  config.vm.provision :install_sql_server, type: "shell", path: "scripts/install-sql-server.ps1"
  config.vm.provision :configure_sql_port, type: "shell", path: "scripts/configure-sql-port.ps1"
  config.vm.provision :enable_rdp, type: "shell", path: "scripts/enable-rdp.ps1"
end
