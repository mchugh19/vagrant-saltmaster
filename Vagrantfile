# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/xenial64"
    master.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/xenial64"
    master.vm.network "forwarded_port", guest: 8000, host: 8000
    master.vm.network "forwarded_port", guest: 80, host: 9080
    master.vm.hostname = 'master'
    master.vm.network "private_network", ip: "192.168.10.2"
    master.vm.synced_folder "saltstack/salt/", "/srv/salt/"
    master.vm.synced_folder "saltstack/pillar/", "/srv/pillar/"
    master.vm.synced_folder "gits/", "/gits/", create: true
  
    master.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end
  
    # Salt Master Provisioner
    master.vm.provision :salt do |salt|
      salt.install_master = true
  
      salt.master_key = "saltstack/key/master.pem"
      salt.master_pub = "saltstack/key/master.pub"
      salt.minion_key = "saltstack/key/minion.pem"
      salt.minion_pub = "saltstack/key/minion.pub"
  
      salt.seed_master = {master: salt.minion_pub}
  
      salt.minion_config = "saltstack/etc/minion"
      salt.minion_id = 'master'
      salt.run_highstate = true
  
      salt.verbose = true
    end
  end

  config.vm.define "minion" do |minion|
    minion.vm.box = "ubuntu/xenial64"
    minion.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/xenial64"
    minion.vm.hostname = 'minion1'
    minion.vm.network "private_network", ip: "192.168.10.3"
  
    minion.vm.provider "virtualbox" do |v|
      v.memory = 512
    end

    # Salt Master Provisioner
    config.vm.provision :salt do |salt|
      salt.install_master = false
  
      salt.minion_key = "saltstack/key/minion.pem"
      salt.minion_pub = "saltstack/key/minion.pub"
  
      salt.seed_master = {master: salt.minion_pub}
  
      salt.minion_config = "saltstack/etc/minion_minion"
      salt.minion_id = 'minion1'
      salt.run_highstate = true
  
      salt.verbose = true
    end
  end
end
