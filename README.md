# Wor::Push::Notifications::Aws

[![Gem Version](https://badge.fury.io/rb/wor-push-notifications-aws.svg)](https://badge.fury.io/rb/wor-push-notifications-aws)
[![Dependency Status](https://gemnasium.com/badges/github.com/Wolox/wor-push-notifications-aws.svg)](https://gemnasium.com/github.com/Wolox/wor-push-notifications-aws)
[![Build Status](https://travis-ci.org/Wolox/wor-push-notifications-aws.svg)](https://travis-ci.org/Wolox/wor-push-notifications-aws)
[![Code Climate](https://codeclimate.com/github/Wolox/wor-push-notifications-aws/badges/gpa.svg)](https://codeclimate.com/github/Wolox/wor-push-notifications-aws)
[![Test Coverage](https://codeclimate.com/github/Wolox/wor-push-notifications-aws/badges/coverage.svg)](https://codeclimate.com/github/Wolox/wor-push-notifications-aws/coverage)

Provide basic setup for storing device tokens and sending Push Notifications to your application using AWS Simple Notification Service (SNS).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wor-push-notifications-aws'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wor-push-notifications-aws

## Configuration
To use the gem, firstly we have to configure it. But don’t worry since the configuration simply consists of these two steps:
1. Firstly, under the config/initializers dir, create the file `wor_push_notifications_aws.rb`:
```ruby
Wor::Push::Notifications::Aws.configure do |config|
  config.device_types = [:ios, :android]       		# optional
  config.table_name = 'users'                 		# optional
  config.aws_region = 'us-east-1'
  config.aws_android_arn = 'some:android:arn'     # mandatory field if you choose to use Android devices
  config.aws_ios_arn = 'some:ios:arn'             # mandatory field if you choose to use iOS devices
  config.aws_ios_sandbox = true                   # mandatory field if you choose to use iOS devices
end
```
If you don't know where to get the arn values, please see [SNS Setup](#sns-setup) section.

2. The following step involves running the install generator, which basically creates a migration file to add a column to your selected table in order to store the tokens. To run the generator, run the following commands:
```ruby
$ rails generate wor:push:notifications:aws:install
$ rake db:migrate
```

## Usage
***Note***: If you haven’t configured sns, now it’s the moment. (See [SNS Setup](#sns-setup)).

So far we have the gem and sns configured, so let’s move to what the gem can do.
As it’s purpose is to make the app send push notifications, there are 3 methods, **add_token**, **delete_token** and **send_message**, to add/delete the device_token, and to send the message.

The device token is a unique token obtained from each pair of App and Device. This token is used for creating an endpoint to identify your users' phones to which you will be sending the push notifications.

The device type identifies from which type of device you have obtained the device token, because the data used for each platform is different.  
iOS and Android are the only device types supported for the moment.

### Add token
Attach device_tokens to a given user instance:
```ruby
Wor::Push::Notifications::Aws.add_token(user, device_token, device_type)
```
#### Parameters
- user: Instance where we want to store the device_token, to which we will send push notifications.
- device_token: Unique identifier you get from the the app.
- device_type: So far we support the values :android or :ios

### Delete token
Delete token from the user instance:
```ruby
Wor::Push::Notifications::Aws.delete_token(user, device_token)
```
#### Parameters
- user: Instance where we want to store the device_token, to which we will send push notifications.
- device_token: Unique identifier you get from the the app.

### Send message
Send a given message to the user instance:
```ruby
Wor::Push::Notifications::Aws.send_message(user, message_content)
```
#### Parameters
- user: Instance which will receive the message. It must have the `device_tokens` from the user's phones.
- message_content: Message you want to send to the user. This parameter must have a JSON format.
  - It **requires** the `message` field.
  - You can add a `badge` field (integer type) to be included in the app icon to show how many pending notifications the user has.
  - You can include any other field in the JSON, with the information you need to send in the push notification

**\*BADGE:** iOS shows the badge automatically, but you have to include it yourself in Android devices.

***message_content example:***

Suppose you have a billing application, you will send the data related to the new bill that has been charged in the system and the amount of unread notifications.

```
message_content = { message: 'You have a new bill!', badge: 5, account_id: 93, bill_id: 45 }
```

## AWS Credentials
In order to use Aws SNS, you'll need to have Aws configured with the right credentials.
You can set up them according to one of the ways explained under the
"credentials" section at http://docs.aws.amazon.com/sdkforruby/api/Aws/SNS/Client.html.
We recommend to use ENV variables with Rails secrets when setting up the configuration.

*Note:* Aws region is specified in the [initializer file](#configuration).

## SNS Setup

**If you HAVE a SNS Application follow this instructions**

- i) Log in the AWS Console
- ii) Click on Services and select Simple Notification Services in Messaging group
- iii) Select Applications tab in the left panel
- iv) You will have your applications' **ARN** listed in a table
- v) When selecting any of them you can see more details of each application, with the information if it's a SANDBOX environment in the iOS case

You will have to create an instance profile for the Elastic Beanstalk environment that's running your application, with the permissions to access the Simple Notification Service or get an AWS_ACCESS_KEY and AWS_SECRET_KEY pair to access this service from outside of AWS.

If you want more information about AWS SNS visit the [documentation](http://docs.aws.amazon.com/sns/latest/dg/SNSMobilePush.html) page.  
If you want more information on how to use AWS with Google Cloud Messaging (for Android) check this [documentation](http://docs.aws.amazon.com/sns/latest/dg/mobile-push-gcm.html).  
If you want more information on how to use AWS with Apple Push Notifications Service (for iOS) check this [documentation](http://docs.aws.amazon.com/sns/latest/dg/mobile-push-apns.html).  

## Requirements
Since a json attribute is needed to store device_tokens on the user table,
Postgres 9.3 or higher is required.

## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run rubocop lint (`bundle exec rubocop -R --format simple`)
5. Run rspec tests (`bundle exec rspec`)
6. Push your branch (`git push origin my-new-feature`)
7. Create a new Pull Request

## About
This project is maintained by [Leandro Masello](https://github.com/lmasello) along with
[Francisco Landino](https://github.com/plandino) and it was written by
[Wolox](http://www.wolox.com.ar).
![Wolox](https://raw.githubusercontent.com/Wolox/press-kit/master/logos/logo_banner.png)

## License
**wor-push-notifications-aws** is available under the MIT [license](https://raw.githubusercontent.com/Wolox/wor-push-notifications-aws/master/LICENSE.txt).
    Copyright (c) 2017 Wolox

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
