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

    entity_ids = entities.map {|s| s['id']}

    Tools::CannedReplies::CannedCategory.where.not(origin_id: entity_ids).delete_all

    roots = _find_children(entities, 0)
    roots.each do |entity_hash|
      _filter_and_insert_category(entities, entity_hash) do |res|
        insert_canned_category res
      end
    end
  end

  def insert_canned_category hsh
    entity = Tools::CannedReplies::Category.new hsh

    entity.persisted_record = Tools::CannedReplies::CannedCategory.find_by_origin_id(entity.origin_id)

    return if entity.private? && !entity.user

    changes_hash = {
      name:       entity.name,
      parent_id:  entity.parent_id { |origin_parent_id| Tools::CannedReplies::CannedCategory.select(:id, :origin_id).find_by_origin_id(origin_parent_id).try(:id) },
      private:    entity.private?,
      user_id:    entity.user_id,
      origin_id:  entity.origin_id
    }

    if entity.persisted? && entity.changed?
      entity.persisted_record.update_attributes(changes_hash)
    elsif !entity.persisted?
      record = Tools::CannedReplies::CannedCategory.new(
        changes_hash
      )
      record.save
    end
  end

  def fetch_macros_categories
    response = Tools::CannedReplies::FetchRequest.call RESOURCES[:macros_categories]
    entities = JSON.parse(response.body)

    entity_ids = entities.map {|s| s['id']}

    Tools::CannedReplies::MacrosCategory.where.not(origin_id: entity_ids).delete_all

    roots = _find_children(entities, 0)

    roots.each do |entity_hash|
      _filter_and_insert_category(entities, entity_hash) do |res|
        insert_macros_category res
      end
    end
  end

  def insert_macros_category hsh

    entity = Tools::CannedReplies::Category.new hsh

    entity.persisted_record = Tools::CannedReplies::MacrosCategory.find_by_origin_id(entity.origin_id)

    return if entity.private? && !entity.user

    changes_hash = {
      name:       entity.name,
      parent_id:  entity.parent_id { |origin_parent_id| Tools::CannedReplies::MacrosCategory.select(:id, :origin_id).find_by_origin_id(origin_parent_id).try(:id) },
      private:    entity.private?,
      user_id:    entity.user_id,
      origin_id:  entity.origin_id
    }

    if entity.persisted? && entity.changed?
      entity.persisted_record.update_attributes(changes_hash)
    elsif !entity.persisted?
      record = Tools::CannedReplies::MacrosCategory.new(
        changes_hash
      )
      record.save
    end

  end

  def fetch_canned_replies
    response = Tools::CannedReplies::FetchRequest.call RESOURCES[:canned_replies]

    entities = JSON.parse(response.body)

    entity_ids = entities.map {|s| s['id']}

    Tools::CannedReplies::CannedReply.where.not(origin_id: entity_ids).delete_all

    entities.each do |entity_hash|
      insert_canned_reply entity_hash
    end
  end

  def insert_canned_reply hsh

    entity = Tools::CannedReplies::Reply.new hsh

    entity.persisted_record = Tools::CannedReplies::CannedReply.find_by_origin_id(entity.origin_id)

    return if entity.private? && !entity.user

    return unless Tools::CannedReplies::CannedCategory.where(origin_id: hsh['category_id']).exists?

    changes_hash = {
      name:         entity.name,
      content:      entity.content,
      category_id:  entity.category_id { |origin_category_id| Tools::CannedReplies::CannedCategory.find_by_origin_id(origin_category_id).try(:id) },
      private:      entity.private?,
      user_id:      entity.user_id,
      origin_id:    entity.origin_id
    }

    if entity.persisted? && entity.changed?
      entity.persisted_record.update_attributes(changes_hash)
    elsif !entity.persisted?
      record = Tools::CannedReplies::CannedReply.new(
        changes_hash
      )
      record.save
    end
  end

  def fetch_macros_replies
    response = Tools::CannedReplies::FetchRequest.call RESOURCES[:macros_replies]

    entities = JSON.parse(response.body)

    entity_ids = entities.map {|s| s['id']}

    Tools::CannedReplies::MacrosReply.where.not(origin_id: entity_ids).delete_all

    entities.each do |entity_hash|
      insert_macros_reply entity_hash
    end
  end

  def insert_macros_reply hsh
    entity = Tools::CannedReplies::Reply.new hsh

    entity.persisted_record = Tools::CannedReplies::MacrosReply.find_by_origin_id(entity.origin_id)

    return if entity.private? && !entity.user

    return unless Tools::CannedReplies::MacrosCategory.where(origin_id: hsh['category_id']).exists?

    changes_hash = {
      name:         entity.name,
      content:      entity.content,
      category_id:  entity.category_id { |origin_category_id| Tools::CannedReplies::MacrosCategory.find_by_origin_id(origin_category_id).try(:id) },
      private:      entity.private?,
      user_id:      entity.user_id,
      origin_id:    entity.origin_id
    }

    if entity.persisted? && entity.changed?
      entity.persisted_record.update_attributes(changes_hash)
    elsif !entity.persisted?
      record = Tools::CannedReplies::MacrosReply.new(
        changes_hash
      )
      record.save
    end
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
