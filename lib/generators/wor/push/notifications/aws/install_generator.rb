require 'rails'
require 'rails/generators'
require 'rails/generators/migration'

module Wor
  module Push
    module Notifications
      module Aws
        module Generators
          class InstallGenerator < Rails::Generators::Base
            include Rails::Generators::Migration
            source_root File.expand_path('./../../../../../templates', __FILE__)

            desc "This generator creates the migration file required to add the attribute
                  device_tokens to the given table"

            def copy_migration
              file_name = 'add_device_token'
              migration_name = "#{file_name}_to_#{table_name}.rb"
              if self.class.migration_exists?('db/migrate', migration_name)
                say_status('skipped', "Migration #{migration_name} already exists")
              else
                migration_template "#{file_name}.rb", "db/migrate/#{migration_name}",
                                   migration_version: migration_version, table_name: table_name
              end
            end

            # Implement the required interface for Rails::Generators::Migration
            def self.next_migration_number(_path)
              Time.now.utc.strftime('%Y%m%d%H%M%S')
            end

            private

            def rails5?
              Rails.version.start_with? '5'
            end

            def migration_version
              "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails5?
            end

            def table_name
              Wor::Push::Notifications::Aws.table_name
            end
          end
        end
      end
    end
  end
end
