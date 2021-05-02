Gem::Specification.new do |gem|
  gem.name = 'firepry'
  gem.summary = 'A Firestore Pry console'
  gem.version = '0.1.0'
  gem.license = 'MIT'

  gem.author = 'Andrew Booth'
  gem.email = 'andrew@andrewbooth.xyz'
  gem.homepage = 'https://github.com/broothie/firepry'

  gem.executables << 'firepry'

  gem.required_ruby_version = '>= 2.5.5'
  gem.add_runtime_dependency 'pry', '~> 0.14.1'
  gem.add_runtime_dependency 'google-cloud-firestore', '~> 2.5.1'
end
