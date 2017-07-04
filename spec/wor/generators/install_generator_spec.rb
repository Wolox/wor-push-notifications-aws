require 'generator_spec'
require 'generators/wor/push/notifications/aws/install_generator'

describe Wor::Push::Notifications::Aws::Generators::InstallGenerator, type: :generator do
  context 'generating the initializer ' do
    destination File.expand_path('./../../../../tmp', __FILE__)

    before(:all) do
      prepare_destination
      run_generator
    end

    let(:migration_version) do
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if Rails.version.start_with? '5'
    end
    let(:current_migration_number) do
      Wor::Push::Notifications::Aws::Generators::InstallGenerator
        .current_migration_number("#{destination_root}/db/migrate/")
    end

    it 'generates the correct structure for initializer' do
      migration_file = "#{current_migration_number}_add_device_token_to_users.rb"
      first_line = "class AddDeviceTokenToUsers < ActiveRecord::Migration#{migration_version}"
      third_line = 'add_column :users, :device_tokens, :json, default: {}'
      expect(destination_root).to(have_structure {
        directory 'db' do
          directory 'migrate' do
            file migration_file do
              contains first_line
              contains third_line
            end
          end
        end
      })
    end
  end
end
