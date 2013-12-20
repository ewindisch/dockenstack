host_cache_path = File.expand_path("../.cache", __FILE__)
guest_cache_path = "/tmp/vagrant-cache"

Vagrant.configure("2") do |config|

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.define :docker do |docker|
    docker.vm.hostname = 'docker'
    docker.vm.box      = 'opscode-ubuntu-13.04'
    docker.vm.box_url  = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-13.04_chef-provisionerless.box'
    docker.vm.network :private_network, ip: '192.168.76.54'
    docker.vm.network "forwarded_port", guest: 80, host: 8080

    docker.vm.provision :chef_solo do |chef|
      chef.provisioning_path  = guest_cache_path
      chef.json               = {}
      chef.run_list           = %w{recipe[apt::default] recipe[docker::default]}
    end

    if ENV['BUILD']
      docker.vm.provision :shell, :inline => <<-SCRIPT
        cd /vagrant
        docker build -t dockenstack .
      SCRIPT
    end

    if ENV['RUN']
      docker.vm.provision :shell, :inline => <<-SCRIPT
        if [[ `docker images dockenstack | head -1 | wc -l` == 1 ]]; then
          docker run -privileged -lxc-conf="aa_profile=unconfined" -d dockenstack
        else
          docker run -privileged -lxc-conf="aa_profile=unconfined" -d paulczar/dockenstack
        fi
        docker ps
      SCRIPT
    end

    docker.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--cpus", 2]
    end
  end

end
