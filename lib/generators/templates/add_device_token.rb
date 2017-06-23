class AddDeviceTokenJsonTo<%= table_name.to_s.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    add_column :<%= table_name %>, :device_tokens, :json, default: {}
  end
end
