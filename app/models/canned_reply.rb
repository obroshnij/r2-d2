class CannedReply < ActiveRecord::Base

  validates :name, presence: true
  has_many :canned_parts, dependent: :destroy
  accepts_nested_attributes_for :canned_parts, allow_destroy: true, reject_if: proc { |a| a['text'].blank? }

end