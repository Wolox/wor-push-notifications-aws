require 'simplecov'
SimpleCov.start
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "wor/push_notifications/aws"
require 'rails'

require 'byebug'
require 'spec_helper'
