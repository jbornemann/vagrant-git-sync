
Gem::Specification.new do |spec|
  spec.name          = 'vagrant-git-sync'
  spec.version       = '1.0.2'
  spec.authors       = ['Jeff Bornemann']
  spec.email         = ['bornemannjs@gmail.com']

  spec.summary       = 'A Vagrant plugin that allows teams to automatically keep Git-backed environments in sync'
  spec.homepage      = 'https://github.com/jbornemann/vagrant-git-sync'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib', 'lib/core']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_runtime_dependency 'net-ping', '~> 1.7'
end
