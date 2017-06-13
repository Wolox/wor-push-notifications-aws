require 'generator_spec'
require 'generators/wor/push_notifications/aws/install_generator'

describe Wor::PushNotifications::Aws::Generators::InstallGenerator, type: :generator do
  context 'generating the initializer ' do
    destination File.expand_path('../../../../tmp', __FILE__)

    before(:all) do
      prepare_destination
      run_generator
    end

    it 'generates the correct structure for initializer' do
      current_migration_number = Wor::PushNotifications::Aws::Generators::InstallGenerator
        .current_migration_number("#{destination_root}/db/migrate/")
      expect(destination_root).to(have_structure{
        directory 'db' do
          directory 'migrate' do
            file "#{current_migration_number}_add_device_token_to_users.rb" do
              contains 'class AddDeviceTokenJsonToUsers < ActiveRecord::Migration[5.0]'
            end
          end
        end
      })
    end
  end
end
