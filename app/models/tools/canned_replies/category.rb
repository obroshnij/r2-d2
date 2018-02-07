class Tools::CannedReplies::Category < ActiveRecord::Base
  # "id", "name", "ancestry", "private", "user_id", "created_at", "updated_at"
  has_ancestry

  belongs_to :user
  has_many :replies
end
