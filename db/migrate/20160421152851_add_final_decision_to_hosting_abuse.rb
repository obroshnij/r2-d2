class AddFinalDecisionToHostingAbuse < ActiveRecord::Migration
  def change
    add_column :legal_hosting_abuse, :decision_id,      :integer
    add_column :legal_hosting_abuse, :disregard_reason, :text
  end
end
