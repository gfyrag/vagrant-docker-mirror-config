require "pathname"

module VagrantPlugins
  module DockerMirrorConfigProvisioner
    class DockerMirrorConfig
      def initialize(machine, config)
        @machine = machine
        @config = config
      end

      def configure
        @machine.communicate.tap do |comm|
          comm.sudo("cp /lib/systemd/system/docker.service /etc/systemd/system/docker.service")
          comm.sudo("sed -ie 's,docker daemon,docker daemon --registry-mirror #{@config.scheme}://#{@config.host}:#{@config.port},g' /etc/systemd/system/docker.service")
          comm.sudo("sed -ie 's,docker daemon,docker daemon --insecure-registry #{@config.host}:#{@config.port},g' /etc/systemd/system/docker.service") if @config.insecure
          comm.sudo("systemctl daemon-reload")
          comm.sudo("systemctl restart docker")
        end
      end
    end
  end
end
