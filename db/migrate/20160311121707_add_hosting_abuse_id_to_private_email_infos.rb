class AddHostingAbuseIdToPrivateEmailInfos < ActiveRecord::Migration
  def change
    add_column :private_email_infos, :hosting_abuse_id, :integer
  end
end