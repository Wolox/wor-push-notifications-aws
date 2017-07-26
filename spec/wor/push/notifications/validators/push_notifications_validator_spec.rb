require 'spec_helper'
require_relative './../mocks/user_with_device_tokens_attribute'
require_relative './../mocks/user_without_device_tokens_attribute'

describe Wor::Push::Notifications::Aws::PushNotificationsValidator do
  subject { described_class.new(model, device_token, device_type) }
  let(:user_mail) { 'example@example.com' }

  describe '#validate_add_token' do
    let(:validate_add_token) { subject.validate_add_token }

    context 'when passing right arguments' do
      let(:model) { UserWithDeviceTokensAttribute.new(user_mail) }
      let(:device_token) { '1234567890' }
      let(:device_type) { :ios }

      it 'does not raise error' do
        expect { validate_add_token }.not_to raise_error
      end
    end

    context 'when the model is nil' do
      let(:model) { nil }
      let(:device_token) { '1234567890' }
      let(:device_type) { :ios }

      it 'raises runtime error with a descriptive message' do
        expect { validate_add_token }.to raise_error(RuntimeError,
                                                     /your entity instance cannot be nil./)
      end
    end

    context 'when the model does not have device_tokens attribute' do
      let(:model) { UserWithoutDeviceTokensAttribute.new(user_mail) }
      let(:device_token) { '1234567890' }
      let(:device_type) { :ios }

      it 'raises runtime error with a descriptive message' do
        expect { validate_add_token }.to raise_error(RuntimeError,
                                                     /Missing attribute device_tokens/)
      end
    end

    context 'with invalid device_type' do
      let(:model) { UserWithDeviceTokensAttribute.new(user_mail) }
      let(:device_token) { '1234567890' }
      let(:device_type) { :iosss }

      it 'raises argument error with a descriptive message' do
        expect { validate_add_token }.to raise_error(ArgumentError,
                                                     /Invalid device_type. It has to be one of /)
      end
    end

    context 'with nil device_token' do
      let(:model) { UserWithDeviceTokensAttribute.new(user_mail) }
      let(:device_token) { nil }
      let(:device_type) { :ios }

      it 'raises argument error with a descriptive message' do
        expect { validate_add_token }.to raise_error(ArgumentError,
                                                     /device_token cannot be nil./)
      end
    end
  end

  describe '#validate_delete_token' do
    let(:validate_delete_token) { subject.validate_delete_token }
    let(:device_token) { nil }
    let(:device_type) { nil }

    context 'when the model is nil' do
      let(:model) { nil }

      it 'raises runtime error with a descriptive message' do
        expect { validate_delete_token }.to raise_error(RuntimeError,
                                                        /your entity instance cannot be nil./)
      end
    end

    context 'when the model contains device_tokens attribute' do
      let(:model) { UserWithDeviceTokensAttribute.new(user_mail) }

      it 'does not raise error' do
        expect { validate_delete_token }.not_to raise_error
      end
    end

    context 'when the model does not have the device_tokens attribute' do
      let(:model) { UserWithoutDeviceTokensAttribute.new(user_mail) }

      it 'raises runtime error with a descriptive message' do
        expect { validate_delete_token }.to raise_error(RuntimeError,
                                                        /Missing attribute device_tokens/)
      end
    end
  end

  describe '#validate_send_message' do
    let(:validate_send_message) { subject.validate_send_message(message_content) }
    let(:device_token) { nil }
    let(:device_type) { nil }

    context 'with valid parameters' do
      let(:message_content) { { message: 'A message' } }
      let(:model) { UserWithDeviceTokensAttribute.new(user_mail) }

      it 'does not raise error' do
        expect { validate_send_message }.not_to raise_error
      end
    end

    context 'when the model is nil' do
      let(:model) { nil }
      let(:message_content) { { other_field: 'some information' } }

      it 'raises runtime error with a descriptive message' do
        expect { validate_send_message }.to raise_error(RuntimeError,
                                                        /your entity instance cannot be nil./)
      end
    end

    context 'with invalid message content' do
      # Does not have 'message' field
      let(:message_content) { { other_field: 'some information' } }
      let(:model) { UserWithDeviceTokensAttribute.new(user_mail) }

      it 'raises runtime error with a descriptive message' do
        expect { validate_send_message }
          .to raise_error(RuntimeError, /the message_content must have a 'message' field/)
      end
    end

    context 'when the model does not have the device_tokens attribute' do
      let(:message_content) { { message: 'A message' } }
      let(:model) { UserWithoutDeviceTokensAttribute.new(user_mail) }

      it 'raises runtime error with a descriptive message' do
        expect { validate_send_message }.to raise_error(RuntimeError,
                                                        /Missing attribute device_tokens/)
      end
    end
  end
end
