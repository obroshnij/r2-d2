class DeleteExtraStuff < ActiveRecord::Migration
  def change
    
    drop_table :canned_replies
    drop_table :canned_parts
    drop_table :reported_domains
    
  end
end
