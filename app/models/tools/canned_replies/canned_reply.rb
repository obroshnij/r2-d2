class Tools::CannedReplies::CannedReply < ActiveRecord::Base
  belongs_to :category, class_name: Tools::CannedReplies::CannedCategory
  belongs_to :user
end
