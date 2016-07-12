require_relative "docker_mirror_config"

module VagrantPlugins
  module DockerMirrorConfigProvisioner
    class Provisioner < Vagrant.plugin("2", :provisioner)
      def initialize(machine, config)
        super(machine, config)
        @docker_mirror = DockerMirrorConfig.new(@machine, @config)
      end

      def provision
        @machine.ui.info("Configuring docker mirror")
        @machine.ui.info(" -> Host : #{@config.host}")
        @machine.ui.info(" -> Port : #{@config.port}")
        @machine.ui.info(" -> TLS : #{@config.tls}")
        @machine.ui.info(" -> Insecure : #{@config.insecure}")
        @docker_mirror.configure
      end
    end
  end
end
