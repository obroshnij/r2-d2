namespace :backup do
  
  desc 'Upload backup config files'
  task :upload_config do
    on roles(:app) do
      execute "mkdir -p #{fetch(:backup_path)}/models"
      upload! "shared/backup/config.rb", "#{fetch(:backup_path)}/config.rb"
      upload! "shared/backup/models/db_backup.rb", "#{fetch(:backup_path)}/models/db_backup.rb"
    end
  end
  
  desc 'Upload cron schedule file'
  task :upload_cron do
    on roles(:app) do
      execute "mkdir -p #{fetch(:backup_path)}/config"
      execute "touch #{fetch(:backup_path)}/config/cron.log"
      upload! "shared/backup/config/schedule.rb", "#{fetch(:backup_path)}/config/schedule.rb"
      
      execute "/home/deployer/.rvm/gems/ruby-2.1.3/wrappers/whenever -f /home/deployer/Backup/config/schedule.rb"
      execute "/home/deployer/.rvm/gems/ruby-2.1.3/wrappers/whenever -f /home/deployer/Backup/config/schedule.rb --update-crontab"
    end
  end
  
end