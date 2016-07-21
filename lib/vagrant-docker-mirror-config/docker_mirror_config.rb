require "pathname"
require "json"
require "vagrant/util/downloader"

module VagrantPlugins
  module DockerMirrorConfigProvisioner
    class DockerMirrorConfig
      def initialize(machine, config)
        @machine = machine
        @config = config
      end

      def configure
        @machine.communicate.tap do |comm|
          json = nil
          if comm.test("test -f /etc/docker/daemon.json", { :sudo => true })
            comm.sudo("cat /etc/docker/daemon.json", { :shell => "/bin/sh" }) do |type, data|
              json = JSON.parse(data)
            end
          else
            json = {}
          end
          registryMirror = "#{@config.scheme}://#{@config.host}:#{@config.port}"
          insecureHost= "#{@config.host}:#{@config.port}"

          json["registry-mirrors"] = [] if not json['registry-mirrors']
          json["registry-mirrors"].insert(0, "#{@config.scheme}://#{@config.host}:#{@config.port}") if not json["registry-mirrors"].include? registryMirror
          json["insecure-registries"] = [] if not json['insecure-registries'] && @config.insecure
          json["insecure-registries"].insert(0, "#{@config.host}:#{@config.port}") if @config.insecure if not json["insecure-registries"].include? insecureHost
          File.open("/tmp/daemon.json", 'w') { |file| file.write(JSON.pretty_generate(json)) }
          comm.upload("/tmp/daemon.json", "/tmp/daemon.json")
          comm.sudo("mv /tmp/daemon.json /etc/docker/daemon.json")
          comm.sudo("systemctl daemon-reload")
          comm.sudo("systemctl restart docker")
        end
      end
    end
  end
end
