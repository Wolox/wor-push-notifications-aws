require 'wor/push/notifications/aws/version'
require 'wor/push/notifications/aws/push_notifications'

module Wor
  module Push
    module Notifications
      module Aws
        DEVICE_TYPES = %i[ios android].freeze

        @config = {
          device_types: DEVICE_TYPES,
          table_name: :users
        }

        def self.configure
          yield self
        end

        # Precondition: types must be an array of symbols containing valid device types.
        #               Every type included in this array must be a valid device type
        #               (you can ask for valid device types with the method valid_device_types).
        #               Default is ['ios' 'android'].
        def self.device_types=(types)
          raise ArgumentError, 'Argument must be an array of symbols' unless types.is_a?(Array)
          types.each do |type|
            raise ArgumentError, "Invalid type #{type}" unless DEVICE_TYPES.include?(type)
          end
          @config[:device_types] = types
        end

        # Precondition: table_name must be a string which points out the name of the table that
        #               will store the device_tokens.
        #               Default is 'users'.
        def self.table_name=(table_name)
          raise ArgumentError, 'Argument must be a string' unless table_name.is_a?(String)
          raise ArgumentError, 'Argument must not be an empty string' if table_name.empty?
          @config[:table_name] = table_name.pluralize.to_sym
        end

        def self.aws_ios_arn=(aws_ios_arn)
          raise ArgumentError, 'Argument must be a string' unless aws_ios_arn.is_a?(String)
          @config[:aws_ios_arn] = aws_ios_arn
        end

        def self.aws_ios_sandbox=(aws_ios_sandbox)
          raise ArgumentError, 'Argument must be a boolean' unless boolean?(aws_ios_sandbox)
          @config[:aws_ios_sandbox] = aws_ios_sandbox
        end

        def self.aws_android_arn=(aws_android_arn)
          raise ArgumentError, 'Argument must be a string' unless aws_android_arn.is_a?(String)
          @config[:aws_android_arn] = aws_android_arn
        end

        def self.aws_region=(aws_region)
          raise ArgumentError, 'Argument must be a string' unless aws_region.is_a?(String)
          @config[:aws_region] = aws_region
        end

        def self.device_types
          @config[:device_types]
        end

        def self.table_name
          @config[:table_name]
        end

        def self.aws_ios_arn
          @config[:aws_ios_arn]
        end

        def self.aws_ios_sandbox
          @config[:aws_ios_sandbox]
        end

        def self.aws_android_arn
          @config[:aws_android_arn]
        end

        def self.aws_region
          @config[:aws_region]
        end

        def self.config
          @config
        end

        def self.add_token(user, device_token, device_type)
          PushNotifications.add_token(user, device_token, device_type.to_sym)
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

        def self.boolean?(value)
          value.is_a?(TrueClass) || value.is_a?(FalseClass)
        end
      end
    end
  end
end
