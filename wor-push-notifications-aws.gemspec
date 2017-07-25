# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wor/push/notifications/aws/version'

Gem::Specification.new do |spec|
  spec.name          = "wor-push-notifications-aws"
  spec.version       = Wor::Push::Notifications::Aws::VERSION
  spec.authors       = ["Leandro Masello", "Francisco Landino"]
  spec.email         = ["francisco.landino@wolox.com.ar", "leandro.masello@wolox.com.ar"]

  spec.summary       = 'Easily send Push Notifications to your application using AWS Simple Notification Service (SNS)'
  spec.description   = 'Provide basic set up for storing device tokens and sending Push Notifications to your application using AWS Simple Notification Service (SNS)'
  spec.homepage      = "https://github.com/Wolox/wor-push-notifications-aws"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_dependency 'railties', '>= 4.1.0', '< 5.2'
  spec.add_dependency 'aws-sdk-rails', "~> 1.0"
end
