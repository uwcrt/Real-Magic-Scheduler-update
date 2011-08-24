set :application, "crt-scheduler"
set :repository,  "https://github.com/feds-sdn/Real-Magic-Scheduler.git"

set :scm, :git

set :bundle_cmd, "/var/lib/gems/1.8/bin/bundle"

set :use_sudo, false

set :skip_db_setup, true

require 'bundler/capistrano'
require 'config/deploy/capistrano_database_yml'

task :dev do
  server "dev.fs.uwaterloo.ca", :web, :app
  role :db, "dev.fs.uwaterloo.ca", :primary => true
  set :deploy_to, "/srv/rails/dev-crt-scheduler.feds.ca"
end

task :prod do
  server "www-app.fs.uwaterloo.ca", :web, :app
  role :db, "www-app.fs.uwaterloo.ca", :primary => true
  set :deploy_to, "/srv/rails/scheduler.crt.feds.ca"
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
