class CreateAbuseReportsUserRelations < ActiveRecord::Migration
  def change
    create_table :abuse_reports_user_relations, id: false do |t|
      t.references :abuse_reports, :user_relations
    end
  end
end
