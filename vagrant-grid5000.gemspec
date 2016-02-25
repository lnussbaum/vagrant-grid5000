# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-grid5000/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-grid5000"
  spec.version       = VagrantPlugins::Grid5000::VERSION
  spec.authors       = ["Lucas Nussbaum"]
  spec.email         = ["lucas.nussbaum@loria.fr"]

  spec.summary       = %q{Vagrant provider plugin for Grid'5000}
  spec.homepage      = "https://github.com/lnussbaum/vagrant-grid5000"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "ruby-cute", "~> 0.4"
end
