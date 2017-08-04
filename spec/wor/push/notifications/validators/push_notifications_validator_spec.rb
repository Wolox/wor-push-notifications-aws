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
        expect { validate_add_token }.to raise_error(ArgumentError,
                                                     /your entity instance cannot be nil./)
      end
    end

    context 'when the model does not have device_tokens attribute' do
      let(:model) { UserWithoutDeviceTokensAttribute.new(user_mail) }
      let(:device_token) { '1234567890' }
      let(:device_type) { :ios }

      it 'raises runtime error with a descriptive message' do
        expect { validate_add_token }.to raise_error(
          Wor::Push::Notifications::Aws::Exceptions::ModelWithoutDeviceTokensAttribute,
          /Missing attribute device_tokens/
        )
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
        expect { validate_delete_token }.to raise_error(ArgumentError,
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
        expect { validate_delete_token }.to raise_error(
          Wor::Push::Notifications::Aws::Exceptions::ModelWithoutDeviceTokensAttribute,
          /Missing attribute device_tokens/
        )
      end
    end
  end

  describe '#validate_model' do
    let(:validate_model) { subject.validate_model }
    let(:device_token) { nil }
    let(:device_type) { nil }

    context 'with valid parameters' do
      let(:model) { UserWithDeviceTokensAttribute.new(user_mail) }

      it 'does not raise error' do
        expect { validate_model }.not_to raise_error
      end
    end

    context 'when the model is nil' do
      let(:model) { nil }

      it 'raises runtime error with a descriptive message' do
        expect { validate_model }.to raise_error(ArgumentError,
                                                 /your entity instance cannot be nil./)
      end
    end

    context 'when the model does not have the device_tokens attribute' do
      let(:model) { UserWithoutDeviceTokensAttribute.new(user_mail) }

      it 'raises runtime error with a descriptive message' do
        expect { validate_model }.to raise_error(
          Wor::Push::Notifications::Aws::Exceptions::ModelWithoutDeviceTokensAttribute,
          /Missing attribute device_tokens/
        )
      end
    end
  end

  describe '.validate_message_content' do
    let(:validate_message_content) { described_class.validate_message_content(message_content) }

    context 'when passing a message_content without a badge field' do
      let(:message_content) { { message: 'A message' } }

      it 'adds the badge field' do
        expect(validate_message_content[:badge]).to eq 1
      end
    end

    context 'when passing a message_content with symbols as keys' do
      let(:message_content) { { message: 'A message' } }

      it 'does not raise error' do
        expect { validate_message_content }.not_to raise_error
      end
    end

    context 'when passing a message_content with strings as keys' do
      let(:message_content) { { 'message' => 'A message' } }

      it 'does not raise error' do
        expect { validate_message_content }.not_to raise_error
      end
    end

    context 'when passing a message_content that is not a Hash' do
      let(:message_content) { [5, 'String'].sample }

      it 'raises argument error with a descriptive message' do
        expect { validate_message_content }
          .to raise_error(ArgumentError, /message_content must be a Hash/)
      end
    end
  end
end
