class CannedReply < ActiveRecord::Base

  validates :name, :body, :title, presence: true

end