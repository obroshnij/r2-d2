class Tools::CannedReplies::MacroCategory < Tools::CannedReplies::Category
  # "id", "name", "ancestry", "private", "user_id", "created_at", "updated_at"
  has_ancestry #:type#: "Tools::CannedReplies::Macro"
end
