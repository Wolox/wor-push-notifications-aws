require 'spec_helper'
require_relative './mocks/user_with_device_tokens_attribute'
require_relative './mocks/sns_client_mock'

describe Wor::Push::Notifications::Aws::PushNotifications do
  before do
    allow(Wor::Push::Notifications::Aws::SnsClient).to receive(:new).and_return(SnsClientMock.new)
  end

  describe '#add_token' do
    subject(:add_token) { described_class.add_token(user, device_token, device_type) }

    let(:user) { UserWithDeviceTokensAttribute.new('user@example.com') }
    let(:device_type) { :android }
    let(:device_token) { 'app:arn:token' }

    it 'validates the method' do
      expect_any_instance_of(Wor::Push::Notifications::Aws::PushNotificationsValidator)
        .to receive(:validate_add_token)
      add_token
    end

    context 'when the user already contains the device_token to add' do
      before { user.device_tokens[device_token] = 'some_value' }

      it 'returns true' do
        expect(add_token).to be true
      end

      it 'does not modify the current value' do
        expect { add_token }.not_to(change { user.device_tokens })
      end
    end

    context 'when the user does not contain the device_token' do
      it 'adds the token' do
        add_token
        expect(user.device_tokens[device_token].keys).to match_array %w[device_type endpoint_arn]
      end

      it 'returns true' do
        expect(add_token).to be true
      end
    end
  end

  describe '#delete_token' do
    subject(:delete_token) { described_class.delete_token(user, device_token) }
    let(:user) { UserWithDeviceTokensAttribute.new('user@example.com') }
    let(:device_token) { 'app:arn:token' }

    it 'validates the method' do
      expect_any_instance_of(Wor::Push::Notifications::Aws::PushNotificationsValidator)
        .to receive(:validate_delete_token)
      delete_token
    end

    context 'when the user does not have the device_token' do
      it 'does not modify the user' do
        expect { delete_token }.not_to(change { user })
      end

      it 'returns true' do
        expect(delete_token).to be true
      end
    end

    context 'when the user has the device_token' do
      before { user.device_tokens[device_token] = 'some_value' }

      it 'Modifies the user\'s device_tokens attribute' do
        expect { delete_token }.to(change { user.device_tokens })
      end

      it 'returns true' do
        expect(delete_token).to be true
      end
    end
  end

  describe '#send_message' do
    subject(:send_message) { described_class.send_message(user, message_content) }
    let(:user) { UserWithDeviceTokensAttribute.new('user@example.com') }
    let(:message_content) { {} }

    it 'validates the method' do
      expect_any_instance_of(Wor::Push::Notifications::Aws::PushNotificationsValidator)
        .to receive(:validate_send_message)
      send_message
    end

    context 'when the user does not contain device token values' do
      it 'returns false' do
        expect(send_message).to be false
      end
    end

    context 'when the user contains device token values' do
      let(:device_token) { 'app:arn:token' }
      let(:device_type) { :android }

      before { described_class.add_token(user, device_token, device_type) }

      it 'calls the sns publish method' do
        expect_any_instance_of(SnsClientMock).to receive(:publish)
        send_message
      end

      it 'returns true' do
        expect(send_message).to be true
      end
    end
  end
end
