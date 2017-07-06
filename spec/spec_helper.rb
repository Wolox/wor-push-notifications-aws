require 'simplecov'
SimpleCov.start
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'wor/push/notifications/aws'
require 'wor/push/notifications/aws/validators/push_notifications_validator'
require 'rails'

require 'byebug'
require 'spec_helper'
