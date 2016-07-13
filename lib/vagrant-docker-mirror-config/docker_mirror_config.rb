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
          #comm.sudo("cp /lib/systemd/system/docker.service /etc/systemd/system/docker.service")
          comm.sudo("mkdir -p /etc/systemd/system/docker.service.d/")
          comm.sudo("mkdir -p /etc/sysconfig")
          options = "DOCKER_OPTS=\""
          options += " --registry-mirror #{@config.scheme}://#{@config.host}:#{@config.port}"
          options += " --insecure-registry #{@config.host}:#{@config.port}" if @config.insecure
          options += "\""
          comm.sudo("echo #{options} > /etc/sysconfig/docker")
          comm.sudo("echo [Service] > /etc/systemd/system/docker.service.d/docker.conf")
          comm.sudo("echo EnvironmentFile=-/etc/sysconfig/docker >> /etc/systemd/system/docker.service.d/docker.conf")
          comm.sudo("echo ExecStart= >> /etc/systemd/system/docker.service.d/docker.conf")
          comm.sudo("echo ExecStart=/usr/bin/docker daemon -H fd:// \\\$DOCKER_OPTS >> /etc/systemd/system/docker.service.d/docker.conf")
          comm.sudo("systemctl daemon-reload")
          comm.sudo("systemctl restart docker")
        end
      end
    end
  end
end
