class Tools::CannedReplies::CannedReply < ActiveRecord::Base
  include PgSearch

  belongs_to :category, class_name: Tools::CannedReplies::CannedCategory
  belongs_to :user

  scope :visible_for, -> (user_id) { where("private=false OR (private=true AND user_id=?)", user_id)}

  pg_search_scope :search_by_name_or_content, against: [:name, :content]
end
