class Tools::CannedReplies::Reply < ActiveRecord::Base
  # "id", "name", "content", "category_id", "private", "user_id", "created_at", "updated_at"
  belongs_to :category
  belongs_to :user
end
