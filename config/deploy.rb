require 'bundler/capistrano'

set :application, "MovieBuddy"
set :repository,  "git@github.com:Joseph-N/moviebuddy.git"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :scm, :git
set :branch, "master"
set :user, "jose"
set :use_sudo, false
set :rails_env, "production" 
set :deploy_via, :copy
set :ssh_options, { :forward_agent => true }
set :keep_releases, 5
set :stages, [:production]
default_run_options[:pty] = true
server "162.243.105.102", :app, :web, :db, :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end

  desc "Symlink shared config files"
  task :symlink_config_files do
    run "#{ sudo } ln -s #{ deploy_to }/shared/config/database.yml #{ current_path }/config/database.yml"
  end

  # NOTE: I don't use this anymore, but this is how I used to do it.
  desc "Precompile assets after deploy"
  task :precompile_assets do
    run <<-CMD
      cd #{ current_path } &&
      #{ sudo } bundle exec rake assets:precompile RAILS_ENV=#{ rails_env }
    CMD
  end

  desc "Restart applicaiton"
  task :restart do
    run "#{ try_sudo } touch #{ File.join(current_path, 'tmp', 'restart.txt') }"
  end
end

after "deploy", "deploy:symlink_config_files"
after "deploy", "deploy:restart"
after "deploy", "deploy:cleanup"