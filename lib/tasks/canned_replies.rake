namespace :canned_replies do
  desc "Fetch replies from remote server"
  task fetch: :environment do
    Tools::CannedReplies::FetchService.call
  end
end
