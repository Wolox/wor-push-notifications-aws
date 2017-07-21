module Wor
  module Push
    module Notifications
      module Aws
        class PushNotificationsValidator
          def initialize(model, device_token = nil, device_type = nil)
            @model = model
            @device_token = device_token
            @device_type = device_type
          end

          def validate_add_token
            validate_existence_of_attributes_in_model
            validate_parameters
          end

          def validate_delete_token
            validate_existence_of_attributes_in_model
          end

          def validate_send_message(message_content)
            validate_existence_of_attributes_in_model
            validate_message_content(message_content)
          end

          private

          def validate_existence_of_attributes_in_model
            raise message_for_missing_attribute unless @model.has_attribute?(:device_tokens)
          end

          def validate_message_content(message_content)
            raise message_for_invalid_message_content if message_content[:message].blank?
          end

          def validate_parameters
            raise ArgumentError, message_for_invalid_device_type unless device_type_valid?
            raise ArgumentError, message_for_nil_device_token if @device_token.blank?
          end

          def message_for_missing_attribute
            'Missing attribute device_tokens for model. Have you run the gem migration?'
          end

          def message_for_invalid_device_type
            "Invalid device_type. It has to be one of the types configured \
             #{Wor::Push::Notifications::Aws.device_types}."
          end

          def message_for_nil_device_token
            'device_token cannot be nil.'
          end

          def message_for_invalid_message_content
            "the message_content must have a 'message' field"
          end

          def device_type_valid?
            Wor::Push::Notifications::Aws.device_types.include? @device_type
          end
        end
      end
    end
  end
end
