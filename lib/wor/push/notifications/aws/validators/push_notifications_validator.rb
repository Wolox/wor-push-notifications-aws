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
            validate_model_existance
            validate_existence_of_attributes_in_model
            validate_parameters
          end

          def validate_delete_token
            validate_model_existance
            validate_existence_of_attributes_in_model
          end

          def validate_model
            validate_model_existance
            validate_existence_of_attributes_in_model
          end

          class << self
            def validate_message_content(message_content)
              raise ArgumentError, message_content_type_error unless message_content.is_a?(Hash)
              message_content = message_content.with_indifferent_access
              raise ArgumentError, message_content_error if message_content[:message].blank?
              badge_check(message_content)
            end

            private

            def message_content_error
              "the message_content must have a 'message' field"
            end

            def message_content_type_error
              'message_content must be a Hash'
            end

            def badge_check(message_content)
              message_content[:badge] ||= 1
              message_content
            end
          end

          private

          def validate_model_existance
            raise ArgumentError, message_for_nil_model if @model.nil?
          end

          def validate_existence_of_attributes_in_model
            return if @model.has_attribute?(:device_tokens)
            raise Wor::Push::Notifications::Aws::Exceptions::ModelWithoutDeviceTokensAttribute,
                  message_for_missing_attribute_in_model
          end

          def validate_parameters
            raise ArgumentError, message_for_invalid_device_type unless device_type_valid?
            raise ArgumentError, message_for_nil_device_token if @device_token.blank?
          end

          def message_for_invalid_device_type
            "Invalid device_type. It has to be one of the types configured \
             #{Wor::Push::Notifications::Aws.device_types}."
          end

          def message_for_missing_attribute_in_model
            'Missing attribute device_tokens for model. Have you run the gem migration?'
          end

          def message_for_nil_device_token
            'device_token cannot be nil.'
          end

          def message_for_nil_model
            'your entity instance cannot be nil.'
          end

          def device_type_valid?
            Wor::Push::Notifications::Aws.device_types.include? @device_type
          end
        end
      end
    end
  end
end
