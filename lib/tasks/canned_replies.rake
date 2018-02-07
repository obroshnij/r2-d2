namespace :canned_replies do
  desc "Fetch replies from remote server"
  task fetch: :environment do
    # ["id", "name", "ancestry", "private", "user_id"
    categories.each do |cat|
       Tools::CannedReplies::Category.create(
         name:      cat[:name],
         parent_id: cat[:parent_name] ? Tools::CannedReplies::Category.find_by(name: cat[:parent_name]).id : nil
       )
    end

    # "id", "name", "content", "category_id", "private", "user_id", "created_at", "updated_at"]
    replies.each do |reply|
      Tools::CannedReplies::Reply.create(
        name:         reply[:name],
        content:      reply[:content],
        category_id:  Tools::CannedReplies::Category.find_by(name: reply[:category_name]).id
      )
    end
  end

  def categories
    [
      {
        name:         "Root category #1",
        parent_name:  nil,
        private:      false
      },
      {
        name:         "Root category #2",
        parent_name:  nil,
        private:      false
      },
      {
        name:         "Child category of root #1",
        parent_name:  "Root category #1",
        private:      false
      },
      {
        name:         "Child #2 category of root #1",
        parent_name:  "Root category #1",
        private:      false
      },
      {
        name:         "Child #1 category of root #2",
        parent_name:  "Root category #2",
        private:      false
      }
    ]
  end

  def replies
    # "id", "name", "content", "category_id", "private", "user_id", "created_at", "updated_at"]
    [
      {
        name:           "reply 1",
        content:        "content",
        category_name:  "Root category #1",
        private:        false
      },
      {
        name:           "reply 2",
        content:        "content",
        category_name:  "Child #2 category of root #1",
        private:        false
      },
      {
        name:           "reply 3",
        content:        "content",
        category_name:  "Child #1 category of root #2",
        private:        false
      },
      {
        name:           "reply 4",
        content:        "content",
        category_name:  "Root category #2",
        private:        false
      }
    ]
  end
end
