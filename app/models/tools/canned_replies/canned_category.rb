class Tools::CannedReplies::CannedCategory < Tools::CannedReplies::Category
  # "id", "name", "ancestry", "private", "user_id", "created_at", "updated_at"
  has_ancestry #type: "Tools::CannedReplies::Canned"

  # belongs_to :user
  # has_many :replies
end
