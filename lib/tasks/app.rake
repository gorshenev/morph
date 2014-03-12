namespace :app do
  desc "Run scrapers that need to run once per day (this task should be called from a cron job)"
  task :auto_run_scrapers => :environment do
    scrapers = Scraper.where(auto_run: true)
    scrapers.each do |scraper|
      # Guard against more than one of a particular scraper running at the same time
      if scraper.runnable?
        run = scraper.runs.create(queued_at: Time.now, auto: true, owner_id: scraper.owner_id)
        RunWorkerAuto.perform_async(run.id)
      end
    end
    puts "Queued #{scrapers.count} scrapers to run now"
  end

  desc "Send out alerts for all users (Run once per day with a cron job)"
  task :send_alerts => :environment do
    User.process_alerts
  end

  desc "Refresh info for all users from github"
  task :refresh_all_users => :environment do
    User.all.each {|user| user.refresh_info_from_github!}
  end

  desc "Build docker image (Needs to be done once before any scrapers are run)"
  task :update_docker_image => :environment do
    Scraper.update_docker_image!
  end

  desc "Synchronise all repositories"
  task :synchronise_repos => :environment do
    Scraper.all.each{|s| s.synchronise_repo}
  end
end
