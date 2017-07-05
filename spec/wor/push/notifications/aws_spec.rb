require 'spec_helper'

describe Wor::Push::Notifications::Aws do
  it 'has a version number' do
    expect(Wor::Push::Notifications::Aws::VERSION).not_to be nil
  end

  describe '.config' do
    it 'has configurations' do
      expect(described_class.config).not_to be nil
    end

    it 'has a default table' do
      expect(described_class.table_name).not_to be nil
    end

    it 'has a default device types' do
      expect(described_class.device_types).not_to be nil
    end
  end

  describe '.configure' do
    context 'when configuring the table name' do
      let!(:default_table_name) { described_class.table_name.to_s }
      context 'with correct values' do
        context 'with table name pluralized' do
          let(:new_table_name) { 'clients' }

          before do
            described_class.configure do |config|
              config.table_name = new_table_name
            end
          end

          it 'can be configured' do
            expect(described_class.table_name).to eq(new_table_name.to_sym)
          end

          after do
            described_class.configure do |config|
              config.table_name = default_table_name
            end
          end
        end

        context 'with table name not pluralized' do
          let(:new_table_name) { 'client' }
          let(:new_table_name_pluralized) { 'client'.pluralize }

          before do
            described_class.configure do |config|
              config.table_name = new_table_name
            end
          end

          it 'can be configured' do
            expect(described_class.table_name).to eq(new_table_name_pluralized.to_sym)
          end

          after do
            described_class.configure do |config|
              config.table_name = default_table_name
            end
          end
        end
      end

      context 'with incorrect values' do
        let(:new_table_name) { 123 }
        let(:wrong_config) do
          described_class.configure do |config|
            config.table_name = new_table_name
          end
        end

        it 'raises ArgumentError' do
          expect { wrong_config }.to raise_error(ArgumentError, 'Argument must be a string')
        end
      end

      context 'with empty name' do
        let(:new_table_name) { '' }
        let(:wrong_config) do
          described_class.configure do |config|
            config.table_name = new_table_name
          end
        end

        it 'raises ArgumentError' do
          expect { wrong_config }.to raise_error(ArgumentError,
                                                 'Argument must not be an empty string')
        end
      end
    end

    context 'when configuring the device types' do
      let!(:default_device_types) { described_class.device_types }
      context 'with correct values' do
        let(:new_device_types) { [:android] }
        before do
          described_class.configure do |config|
            config.device_types = new_device_types
          end
        end

        it 'can be configured' do
          expect(described_class.device_types).to eq(new_device_types)
        end

        after do
          described_class.configure do |config|
            config.device_types = default_device_types
          end
        end
      end
      context 'with incorrect values' do
        context 'with incorrect argument (syntactically)' do
          let(:new_device_types) { :ios }
          let(:wrong_config) do
            described_class.configure do |config|
              config.device_types = new_device_types
            end
          end

          it 'raises ArgumentError' do
            expect { wrong_config }.to raise_error(ArgumentError,
                                                   'Argument must be an array of symbols')
          end
        end
        context 'with invalid type (semantically)' do
          let(:new_device_types) { %i[android ois] }
          let(:wrong_config) do
            described_class.configure do |config|
              config.device_types = new_device_types
            end
          end

          it 'raises ArgumentError' do
            expect { wrong_config }.to raise_error(ArgumentError, /Invalid type/)
          end
        end
      end
    end

    context 'when configuring aws region' do
      context 'with correct argument' do
        let(:aws_region) { 'us-west-1' }
        before do
          described_class.configure do |config|
            config.aws_region = aws_region
          end
        end

        it 'can be configured' do
          expect(described_class.aws_region).to eq(aws_region)
        end
      end

      context 'with incorrect argument' do
        let(:wrong_aws_region) { 1234 }
        let(:wrong_config) do
          described_class.configure do |config|
            config.aws_region = wrong_aws_region
          end
        end

        it 'raises ArgumentError' do
          expect { wrong_config }.to raise_error(ArgumentError, /Argument must be a string/)
        end
      end
    end

    context 'when configuring aws ios arn' do
      context 'with correct argument' do
        let(:aws_ios_arn) { 'arn:aws:app/APNS_SANDBOX' }
        before do
          described_class.configure do |config|
            config.aws_ios_arn = aws_ios_arn
          end
        end

        it 'can be configured' do
          expect(described_class.aws_ios_arn).to eq(aws_ios_arn)
        end
      end

      context 'with incorrect argument' do
        let(:wrong_arn) { 1234 }
        let(:wrong_config) do
          described_class.configure do |config|
            config.aws_ios_arn = wrong_arn
          end
        end

        it 'raises ArgumentError' do
          expect { wrong_config }.to raise_error(ArgumentError, /Argument must be a string/)
        end
      end
    end

    context 'when configuring aws ios sandbox' do
      context 'with correct argument' do
        let(:aws_ios_sandbox) { [true, false].sample }
        before do
          described_class.configure do |config|
            config.aws_ios_sandbox = aws_ios_sandbox
          end
        end

        it 'can be configured' do
          expect(described_class.aws_ios_sandbox).to eq(aws_ios_sandbox)
        end
      end

      context 'with incorrect argument' do
        let(:wrong_aws_ios_sandbox) { 'true' }
        let(:wrong_config) do
          described_class.configure do |config|
            config.aws_ios_sandbox = wrong_aws_ios_sandbox
          end
        end

        it 'raises ArgumentError' do
          expect { wrong_config }.to raise_error(ArgumentError, /Argument must be a boolean/)
        end
      end
    end

    context 'when configuring aws android arn' do
      context 'with correct argument' do
        let(:aws_android_arn) { 'arn:aws:app/GCM' }
        before do
          described_class.configure do |config|
            config.aws_android_arn = aws_android_arn
          end
        end

        it 'can be configured' do
          expect(described_class.aws_android_arn).to eq(aws_android_arn)
        end
      end

      context 'with incorrect argument' do
        let(:wrong_arn) { 1234 }
        let(:wrong_config) do
          described_class.configure do |config|
            config.aws_android_arn = wrong_arn
          end
        end

        it 'raises ArgumentError' do
          expect { wrong_config }.to raise_error(ArgumentError, /Argument must be a string/)
        end
      end
    end
  end
end
