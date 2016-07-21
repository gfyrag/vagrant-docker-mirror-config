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
          if comm.test("cat /etc/docker/daemon.json 2>&1")
            json = comm.sudo("cat /etc/docker/daemon.json 2>&1")
            json = json.parse(json)
          else
            json = {}
          end
          json["registry-mirrors"] = [] if not json['registry-mirrors']
          json["registry-mirrors"].insert(0, "#{@config.scheme}://#{@config.host}:#{@config.port}")
          json["insecure-registries"] = [] if not json['insecure-registries'] && @config.insecure
          json["insecure-registries"].insert(0, "#{@config.host}:#{@config.port}") if @config.insecure
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
