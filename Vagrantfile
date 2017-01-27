## A Vagrantfile to run an instance based on
## Ubuntu 16.04 with Ansible provisioner by
## Roozbeh Shafiee (me@roozbeh.cloud)

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory="4096"
  end

  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/deploy.yml"
  end

end
