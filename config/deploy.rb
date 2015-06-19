# config valid only for current version of Capistrano
lock '3.4.0'
set :passenger_restart_with_touch, true

set :application, 'rails_tutorial_template'
set :repo_url, 'https://github.com/RaphaelDeLaGhetto/rails-tutorial-template'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/rails-tutorial-template'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/application.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'node_modules')

set :passenger_restart_with_sudo, true

# deploy
namespace :deploy do

  # 2015-4-14 https://gist.github.com/ryanray/7579912
  desc 'Install node modules'
  task :npm_install do
    on roles(:app) do
      execute "cd #{release_path} && npm install"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  before :updated, 'deploy:npm_install'
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
