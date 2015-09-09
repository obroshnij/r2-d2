class CreateSblInfos < ActiveRecord::Migration
  def change
    create_table :sbl_infos do |t|
      t.integer  :sbl_id
      t.string   :ip_range
      t.datetime :date
      t.text     :info
      t.boolean  :rokso
      t.boolean  :active, default: true
      t.boolean  :removal_requested
      t.string   :complaint
      t.boolean  :client_responded
      t.text     :comment

      t.timestamps null: false
    end
  end
end
