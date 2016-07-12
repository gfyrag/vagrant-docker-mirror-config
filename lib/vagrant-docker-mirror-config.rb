require "pathname"

require "vagrant-docker-mirror-config/plugin"

module VagrantPlugins
  module DockerMirrorConfigProvisioner
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end
  end
end
