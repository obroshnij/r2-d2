class AddDataToRbls < ActiveRecord::Migration
  def change
    add_column :rbls, :data, :json, default: {}
  end
end
