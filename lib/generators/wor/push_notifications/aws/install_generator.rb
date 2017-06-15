require 'rails/generators'
require 'rails/generators/migration'
module Wor
  module PushNotifications
    module Aws
      module Generators
        class InstallGenerator < Rails::Generators::Base
          include Rails::Generators::Migration
          source_root File.expand_path('../../../../templates', __FILE__)

          desc "This generator creates the migration file required to add the attribute
                device_tokens to the given table"

          def copy_migration
            file_name = 'add_device_token'
            table_name = 'users'
            migration_name = "#{file_name}_to_#{table_name}.rb"
            if self.class.migration_exists?('db/migrate', migration_name)
              say_status('skipped', "Migration #{migration_name} already exists")
            else
              migration_template "#{file_name}.rb", "db/migrate/#{migration_name}"
            end
          end

          # Implement the required interface for Rails::Generators::Migration
          def self.next_migration_number(_path)
            Time.now.utc.strftime('%Y%m%d%H%M%S')
          end
        end
      end
    end
  end
end
