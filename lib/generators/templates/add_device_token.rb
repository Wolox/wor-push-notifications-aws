class AddDeviceTokenJsonToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :device_tokens, :json, default: {}
  end
end
