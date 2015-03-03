class Spammer < ActiveRecord::Base

  before_save { username.downcase! }
  validates :username, presence: true, uniqueness: { message: "has already been added" }
  
  def self.search(search_by, search, page, per_page)
    if search
      where("lower(#{search_by}) LIKE ?", "%#{search.downcase.strip}%").paginate(page: page, per_page: per_page)
    else
      all.paginate(page: page, per_page: 25)
    end
  end

end