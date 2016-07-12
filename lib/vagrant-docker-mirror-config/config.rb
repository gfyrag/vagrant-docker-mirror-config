module VagrantPlugins
  module DockerMirrorConfigProvisioner

    class ConfigError < Vagrant::Errors::VagrantError
    end

    class Config < Vagrant.plugin("2", :config)
      attr_accessor :tls, :host, :port, :scheme, :insecure

      def initialize
        @tls = false
        @host = UNSET_VALUE
        @port = 5000
        @scheme = "http"
        @insecure = false
      end

      def finalize!
        @tls = true if ENV["DOCKER_MIRROR_TLS"] == "yes"
        @host = ENV["DOCKER_MIRROR_HOST"] if @host == UNSET_VALUE
        @port = ENV["DOCKER_MIRROR_PORT"] if ENV["DOCKER_MIRROR_PORT"]
        @insecure = true if ENV["DOCKER_MIRROR_INSECURE"] == "yes"
        @scheme = "https" if @tls
        @scheme = "http" if not @tls

        raise ConfigError.new(:host_undefined, "Undefined") if not @host
      end
    end
  end
end
