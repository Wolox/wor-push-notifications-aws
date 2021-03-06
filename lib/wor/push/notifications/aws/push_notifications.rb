require 'wor/push/notifications/aws/android_push_json_builder'
require 'wor/push/notifications/aws/ios_push_json_builder'
require 'wor/push/notifications/aws/validators/push_notifications_validator'
require 'aws-sdk-rails'

module Wor
  module Push
    module Notifications
      module Aws
        class PushNotifications
          class << self
            def add_token(user, device_token, device_type)
              PushNotificationsValidator.new(user, device_token, device_type).validate_add_token
              device_token = device_token.to_s.gsub(/\s+/, '')
              return true if user.device_tokens.key?(device_token)
              endpoint = sns.create_platform_endpoint(
                platform_application_arn: app_arn(device_type), token: device_token
              )
              user.device_tokens[device_token] = { 'device_type' => device_type,
                                                   'endpoint_arn' => endpoint[:endpoint_arn] }
              user.save
            end

            def delete_token(user, device_token)
              PushNotificationsValidator.new(user).validate_delete_token
              device_token = device_token.to_s.gsub(/\s+/, '')
              return true unless user.device_tokens.key?(device_token)
              sns.delete_endpoint(endpoint_arn: user.device_tokens[device_token]['endpoint_arn'])
              user.device_tokens.delete(device_token)
              user.save
            end

            def send_message(user, message_content)
              PushNotificationsValidator.new(user).validate_model
              message_content = PushNotificationsValidator.validate_message_content(
                message_content
              )
              send_notifications_to_user(user, message_content)
            end

            private

            def send_notifications_to_user(user, message_content)
              return false if user.device_tokens.values.empty?
              send_notifications_to_devices(user, message_content)
              true
            end

            def send_notifications_to_devices(user, message_content)
              user.device_tokens.each do |device_token, token|
                message = prepare_message(token['device_type'], message_content)
                begin
                  sns.publish(target_arn: token['endpoint_arn'], message: message.to_json,
                              message_structure: 'json')
                rescue
                  user.device_tokens.delete(device_token)
                end
              end
              user.save if user.device_tokens_changed?
            end

            def prepare_message(device_type, message_content)
              app_arn_for_device[device_type.to_sym][:json_builder].build_json(message_content)
            end

            def sns
              @sns_client ||= ::Aws::SNS::Client.new(
                region: Wor::Push::Notifications::Aws.aws_region
              )
            end

            def app_arn(device_type)
              app_arn_for_device[device_type.to_sym][:arn]
            end

            def app_arn_for_device
              {
                ios: {
                  arn: Wor::Push::Notifications::Aws.aws_ios_arn,
                  json_builder: IosPushJsonBuilder
                },
                android: {
                  arn: Wor::Push::Notifications::Aws.aws_android_arn,
                  json_builder: AndroidPushJsonBuilder
                }
              }
            end
          end
        end
      end
    end
  end
end
