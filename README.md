# Vagrant Provisioner: Docker Mirror config

A Vagrant provisioner for setup a remote docker mirror.

## Install

```bash
vagrant plugin install vagrant-docker-mirror-config
```

## Usage

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"

  config.vm.provision :docker
  config.vm.provision :docker_mirror_config, :host => "192.168.1.2", :port => 5001, :insecure => true, :tls => true
end

You can also use following environment variables :
* `DOCKER_DOCKER_MIRROR_TLS` optionnal, default is disabled
* `DOCKER_DOCKER_MIRROR_HOST` required
* `DOCKER_DOCKER_MIRROR_PORT` optionnal, default is 5000
* `DOCKER_DOCKER_MIRROR_INSECURE` optional, default is false