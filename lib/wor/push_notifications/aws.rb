require 'wor/push_notifications/aws/version'
require 'wor/push_notifications/aws/push_notifications'

module Wor
  module PushNotifications
    module Aws
      def add_token(user, device_token, device_type)
        PushNotifications.add_token(user, device_token, device_type)
      end

      def delete_token(user, device_token)
        PushNotifications.delete_token(user, device_token)
      end

      def send_message(user, message_content)
        PushNotifications.send_message(user, message_content)
      end
    end
  end
end
