require 'bundler/capistrano'
require 'pathname'

APP_CONFIG = YAML.load_file("config/app_config.yml")

set :application, "MAD Booking"
set :repository,  "ssh://git@github.com/jmccarth/mad-booking.git"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "env-rails.uwaterloo.ca"                          # Your HTTP server, Apache/etc
role :app, "env-rails.uwaterloo.ca"                          # This may be the same as your `Web` server
role :db,  "env-rails.uwaterloo.ca", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :user, 'jmccarth'
#set :deploy_to, '/home/Sites/ecology-booking/'
set :deploy_to, Capistrano::CLI.ui.ask("Deploy path:")
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :use_sudo, true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"
after "deploy:finalize_update", "deploy:symlink_config_files"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end

    desc "Symlink shared config files"
	task :symlink_config_files do
		run "#{try_sudo} ln -fs #{ deploy_to }shared/config/database.yml #{release_path}/config/database.yml"
		run "#{try_sudo} ln -fs #{ deploy_to }shared/config/mail_secrets.yml #{release_path}/config/mail_secrets.yml"
		run "#{try_sudo} ln -fs #{ deploy_to }shared/config/app_config.yml #{release_path}/config/app_config.yml"
	end
end
