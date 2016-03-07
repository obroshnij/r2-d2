object false

child :@resources => :items do
  attributes :name, :description
  
  child :permission_groups do
    attributes :name, :exclusive
    
    child :permissions do
      attributes :id, :description, :action_type
    end
  end
  
end