require 'wor/push_notifications/aws/version'
require 'wor/push_notifications/aws/push_notifications'

module Wor
  module PushNotifications
    module Aws
      DEVICE_TYPES = %w[ios android].freeze

      @config = {
        device_types: DEVICE_TYPES,
        table_name: 'users'
      }

      def self.configure
        yield self
      end

      # Precondition: types must be an array of strings containing valid device types.
      #               Every type included in this array must be a valid device type
      #               (you can ask for valid device types with the method valid_device_types).
      #               Default is ['ios' 'android'].
      def self.device_types=(types)
        raise ArgumentError, 'Argument must be an array of strings' unless types.is_a?(Array)
        types.each do |type|
          raise ArgumentError, "Invalid type #{type}" unless DEVICE_TYPES.include?(type)
        end
        @config[:device_types] = types
      end

      # Precondition: table_name must be a string which points out the name of the table that will
      #               store the device_tokens.
      #               Default is 'users'.
      def self.table_name=(table_name)
        raise ArgumentError, 'Argument must be a string' unless table_name.is_a?(String)
        raise ArgumentError, 'Argument must not be an empty string' if table_name.empty?
        @config[:table_name] = table_name.pluralize
      end

      def self.device_types
        @config[:device_types]
      end

      def self.table_name
        @config[:table_name]
      end

      def self.config
        @config
      end

      def self.add_token(user, device_token, device_type)
        PushNotifications.add_token(user, device_token, device_type)
      end

      def self.delete_token(user, device_token)
        PushNotifications.delete_token(user, device_token)
      end

      def self.send_message(user, message_content)
        PushNotifications.send_message(user, message_content)
      end

      def self.valid_device_types
        DEVICE_TYPES
      end
    end
  end
end
