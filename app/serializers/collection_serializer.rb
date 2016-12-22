class CollectionSerializer < ActiveModel::Serializer::CollectionSerializer

  def root
    'items'
  end

end
