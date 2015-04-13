# config valid only for current version of Capistrano
lock '3.4.0'

set :application, '1000yearfilms'
set :repo_url, 'git@d.libertyseeds.ca:/opt/git/1000yearfilms.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/1000yearfilms'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/application.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

set :passenger_restart_with_sudo, true

# deploy
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
