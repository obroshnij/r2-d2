class Tools::CannedReplies::MacrosReply < ActiveRecord::Base
  belongs_to :category, class_name: Tools::CannedReplies::MacrosCategory
  belongs_to :user
end
