$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.2'        # Or whatever env you want it to run in.

set :application, "lucidity"
set :repository,  "citadel.jeremyroman.com:/home/jeremy/lucidity.git"

set :scm, :git
set :deploy_via, :remote_cache
set :use_sudo, false

role :web, "citadel.jeremyroman.com"
role :app, "citadel.jeremyroman.com"
role :db,  "citadel.jeremyroman.com", :primary => true

depend :remote, :gem, "bundler", ">=1.0.0.rc.2"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  
  desc "Restart application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  desc "Symlink shared resources"
  task :symlink_shared, :roles => :app do
    ["config/database.yml"].each do |file|
      run "ln -nfs #{shared_path}/#{file} #{release_path}/#{file}"
    end
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'

namespace :bundler do
  desc "Symlink bundled gems"
  task :symlink, :roles => :app do
    run "mkdir -p #{shared_path}/gems"
    run "ln -nfs #{shared_path}/gems #{release_path}/vendor/bundle"
  end
  
  desc "Install for production"
  task :install, :roles => :app do
    run "cd #{release_path} && bundle install --deployment"
  end
end

after 'deploy:update_code', 'bundler:symlink'
after 'deploy:update_code', 'bundler:install'
after 'deploy:update_code', 'deploy:migrate'