# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wor/push_notifications/aws/version'

Gem::Specification.new do |spec|
  spec.name          = "wor-push_notifications-aws"
  spec.version       = Wor::PushNotifications::Aws::VERSION
  spec.authors       = ["Leandro Masello", "Francisco Landino"]
  spec.email         = ["francisco.landino@wolox.com.ar", "leandro.masello@wolox.com.ar"]

  spec.summary       = 'Easily add push notifications to your application'
  spec.description   = 'Generate the configuration needed to provide push notifications using Amazon SNS service.'
  spec.homepage      = "https://github.com/Wolox/wor-pushes-aws"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '>= 4.0'
  spec.add_dependency 'aws-sdk-rails', "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'rspec-rails', '~> 3.5'
  spec.add_development_dependency 'byebug', '~> 9.0'
  spec.add_development_dependency 'rubocop', '~> 0.47'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0.0'
  spec.add_development_dependency 'generator_spec'
  spec.add_development_dependency 'simplecov'
end
