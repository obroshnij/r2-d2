class AddActionToAbuseNotesInfos < ActiveRecord::Migration
  def change
    add_column :abuse_notes_infos, :action, :string
  end
end