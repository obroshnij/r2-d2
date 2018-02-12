class Tools::CannedReplies::FetchService
  RESOURCES = {
    canned_categories: "/canned_and_macros/canned_categories.json",
    macros_categories: "/canned_and_macros/macros_categories.json",
    canned_replies:    "/canned_and_macros/canned.json",
    macros_replies:    "/canned_and_macros/macros.json"
  }.freeze

  attr_accessor :data

  def self.call
    service = new
    service.send :perform
  end

  private

  def perform
    RESOURCES.keys.each do |resource_key|
      send "fetch_#{resource_key}"
    end
  end

  def fetch_canned_categories
    response = Tools::CannedReplies::FetchRequest.call RESOURCES[:canned_categories]
    entities = JSON.parse(response.body)

    Tools::CannedReplies::CannedCategory.delete_all

    roots = _find_children(entities, 0)

    roots.each do |entity_hash|
      _filter_and_insert_category(entities, entity_hash) do |res|
        insert_canned_category res
      end
    end
  end

  def insert_canned_category hsh
    entity = Tools::CannedReplies::Category.new hsh

    return if entity.private? && !entity.user

    record = Tools::CannedReplies::CannedCategory.new(
      id:         entity._id,
      name:       entity.name,
      parent_id:  entity.parent_id,
      private:    entity.private?,
      user_id:    entity.user_id
    )
    record.save
  end

  def fetch_macros_categories
    response = Tools::CannedReplies::FetchRequest.call RESOURCES[:macros_categories]
    entities = JSON.parse(response.body)

    Tools::CannedReplies::MacrosCategory.delete_all

    roots = _find_children(entities, 0)

    roots.each do |entity_hash|
      _filter_and_insert_category(entities, entity_hash) do |res|
        insert_macros_category res
      end
    end
  end

  def insert_macros_category hsh
    entity = Tools::CannedReplies::Category.new hsh

    return if entity.private? && !entity.user

    record = Tools::CannedReplies::MacrosCategory.new(
      id:         entity._id,
      name:       entity.name,
      parent_id:  entity.parent_id,
      private:    entity.private?,
      user_id:    entity.user_id
    )
    record.save
  end

  def fetch_canned_replies
    response = Tools::CannedReplies::FetchRequest.call RESOURCES[:canned_replies]

    entities = JSON.parse(response.body)

    Tools::CannedReplies::CannedReply.delete_all

    entities.each do |entity_hash|
      insert_canned_reply entity_hash
    end
  end

  def insert_canned_reply hsh
    entity = Tools::CannedReplies::Reply.new hsh

    return if entity.private? && !entity.user

    return unless Tools::CannedReplies::CannedCategory.where(id: entity.category_id).exists?

    record = Tools::CannedReplies::CannedReply.new(
      id:           entity._id,
      name:         entity.name,
      content:      entity.content,
      category_id:  entity.category_id,
      private:      entity.private?,
      user_id:      entity.user_id
    )
    record.save
  end

  def fetch_macros_replies
    response = Tools::CannedReplies::FetchRequest.call RESOURCES[:macros_replies]

    entities = JSON.parse(response.body)

    Tools::CannedReplies::MacrosReply.delete_all

    entities.each do |entity_hash|
      insert_macros_reply entity_hash
    end
  end

  def insert_macros_reply hsh
    entity = Tools::CannedReplies::Reply.new hsh

    return if entity.private? && !entity.user

    return unless Tools::CannedReplies::MacrosCategory.where(id: entity.category_id).exists?

    record = Tools::CannedReplies::MacrosReply.new(
      id:           entity._id,
      name:         entity.name,
      content:      entity.content,
      category_id:  entity.category_id,
      private:      entity.private?,
      user_id:      entity.user_id
    )
    record.save
  end


  def _filter_and_insert_category(collection, hsh, &block)
    block.call hsh
    children = _find_children(collection, hsh['id'])
    children.each do |child|
      _filter_and_insert_category(collection, child, &block)
    end
  end

  def _find_children collection, key
    collection.select {|e| e['parent_category_id'] == key}
  end

end
