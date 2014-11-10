class Spammer < ActiveRecord::Base

  before_save { username.downcase! }
  
  validates :username, presence: true, uniqueness: { message: "has already been added" }

end