require 'simplecov'
SimpleCov.start
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'wor/push/notifications/aws'
require 'wor/push/notifications/aws/exceptions'
require 'rails'

require 'byebug'
