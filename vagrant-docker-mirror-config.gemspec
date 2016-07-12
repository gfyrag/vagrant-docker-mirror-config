# -*- encoding: utf-8 -*-

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "vagrant-docker-mirror-config/version"

Gem::Specification.new do |s|
  s.name        = "vagrant-docker-mirror-config"
  s.version     = VagrantPlugins::DockerMirrorConfigProvisioner::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Geoffrey Ragot"]
  s.homepage    = "https://github.com/gfyrag/vagrant-docker-mirror-config"
  s.summary     = %q{A Vagrant provisioner for configuring mirror for docker.}
  s.description = %q{A Vagrant provisioner for configuring mirror for docker.}

  s.files        = `git ls-files -z`.split("\0")
  s.require_path = "lib"
end
