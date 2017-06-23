require "spec_helper"

describe Wor::PushNotifications::Aws do
  it "has a version number" do
    expect(Wor::PushNotifications::Aws::VERSION).not_to be nil
  end

  describe '.config' do
    it 'has configurations' do
      expect(described_class.config).not_to be nil
    end

    it 'has a default table' do
      expect(described_class.config[:table_name]).not_to be nil
    end

    it 'has a default device types' do
      expect(described_class.config[:device_types]).not_to be nil
    end
  end

  describe '.configure' do
    context 'when configuring the table name' do
      let!(:default_table_name) { described_class.config[:table_name].to_s }
      context 'with correct values' do
        context 'with table name pluralized' do
          let(:new_table_name) { 'clients' }

          before do
            described_class.configure do |config|
              config.table_name = new_table_name
            end
          end

          it 'can be configured' do
            expect(described_class.config[:table_name]).to eq(new_table_name.to_sym)
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
            expect(described_class.config[:table_name]).to eq(new_table_name_pluralized.to_sym)
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
      let!(:default_device_types) { described_class.config[:device_types] }
      context 'with correct values' do
        let(:new_device_types) { [:android] }
        before do
          described_class.configure do |config|
            config.device_types = new_device_types
          end
        end

        it 'can be configured' do
          expect(described_class.config[:device_types]).to eq(new_device_types)
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
          let(:new_device_types) { [:android, :ois] }
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
  end
end
