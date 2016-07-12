module VagrantPlugins
  module DockerMirrorConfigProvisioner
    class Plugin < Vagrant.plugin("2")
      name "vagrant-docker-mirror-config"
      description <<-DESC
      Provides support for provisioning your virtual machines that run Docker, by configuring reachable mirrors.
      DESC

      config(:docker_mirror_config, :provisioner) do
        require_relative "config"
        Config
      end

      provisioner(:docker_mirror_config) do
        require_relative "provisioner"
        Provisioner
      end
    end
  end
end
