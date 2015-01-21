class VipDomain < ActiveRecord::Base

  before_save { domain.downcase!; username.downcase! }

  validates :domain, presence: true, uniqueness: { message: "has already been added" }
  validates :username, presence: true

end