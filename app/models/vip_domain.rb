class VipDomain < ActiveRecord::Base

  before_save { domain.downcase!; username.downcase! }
  validates :domain, presence: true, uniqueness: { message: "has already been added" }
  validates :username, presence: true
  
  def self.search(search_by, search, page, per_page)
    if search
      where("lower(#{search_by}) LIKE ?", "%#{search.downcase.strip}%").paginate(page: page, per_page: per_page)
    else
      all.paginate(page: page, per_page: 25)
    end
  end

end