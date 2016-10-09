# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Vagrant Box
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/xenial64"
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.hostname = 'master'
  config.vm.synced_folder "saltstack/salt/", "/srv/salt/"

  # Salt Master Provisioner
  config.vm.provision :salt do |salt|
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
