class Tools::CannedReplies::MacrosReply < ActiveRecord::Base
  include PgSearch

  belongs_to :category, class_name: Tools::CannedReplies::MacrosCategory
  belongs_to :user

  pg_search_scope :search_by_name_or_content, against: [:name, :content]
end
