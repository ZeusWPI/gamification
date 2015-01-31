namespace :webhooks do

  desc "Set webhooks on all repositories"
  task create: :environment do
    Repository.all.each do |repo|
      repo.set_webhook
    end
  end

  desc "Delete all webhooks"
  task delete: :environment do
    Repository.all.each do |repo|
      repo.delete_webhook
    end
  end

end
