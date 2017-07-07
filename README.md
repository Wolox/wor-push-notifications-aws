# Wor::Push::Notifications::Aws
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
To use the gem, firstly we have to configure it. But don’t worry since the configuration simply consists of these three steps:
1. Firstly, add `require 'aws-sdk-rails'` to your application.rb in order to include the required aws modules. Once then, you’ll be able to configure your aws instance (see [AWS credentials](#aws-credentials) section).
2. Then, under the config/initializers dir, create the file `wor_push_notifications_aws.rb`, with:
```ruby
Wor::Push::Notifications::Aws.configure do |config|
  config.device_types = [:ios, :android] 		# optional
  config.table_name = 'users'          			# optional
  config.aws_region = 'us-east-1'
  config.aws_android_arn = 'android:arn'
  config.aws_ios_arn = 'ios:arn'
  config.aws_ios_badge = true/false
end
```
If you don't know where to get the arn values, please see [SNS Setup](#sns-setup) section.

3. The last step involves running the install generator, which basically will create a migration file so that we add a column to your selected table which will store the tokens. To run the generator, run the following commands:
```ruby
$ rails generate wor:push:notifications:aws:install
$ rake db:migrate
```

## Usage
***Note***: If you haven’t configured sns, now it’s the moment. (See [SNS Setup](#sns-setup)).

So far we have the gem and sns configured, so let’s move to what the gem can do.
As it’s purpose is to make the app send push notifications, there are 3 methods, **add_token**, **delete_token** and **send_message**, to add/delete the device_token, and to send the message.

***[here some comments about device token and device type.]***

### Add token
Attach device_tokens to a given user instance:
```ruby
PushNotifications.add_token(user, device_token, device_type)
```
#### Parameters
- user: Instance where we want to add the device_token so that we can send push notifications.
- device_token
- device_type: So far we support the values :android or :ios

### Delete token
Delete token from the user instance:
```ruby
PushNotifications.delete_token(user, device_token)
```
#### Parameters
- user: Instance where we want to add the device_token so that we can send push notifications.
- device_token

### Send message
Send a given message to the user instance:
```ruby
PushNotifications.send_message(user, message_content)
```
#### Parameters
- user: Instance which will receive the message. It must have added the device_token before.
- message_content: Message we want to send to the user.
                   This parameter must follow a specific format.
                   ***[Some comments about the format of the message_content ( { message: "bla bla"} )]***

## AWS Credentials
In order to use Aws SNS, you'll need to have Aws configured with the right credentials.
You can set up them according to one of the ways explained under the
"credentials" section at http://docs.aws.amazon.com/sdkforruby/api/Aws/SNS/Client.html.
We recommend to use ENV variables with Rails secrets when setting up the configuration.

*Note:* Aws region is specified in the [initializer file](#configuration).
## SNS Setup
***[Tutorial to setup SNS]***

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
