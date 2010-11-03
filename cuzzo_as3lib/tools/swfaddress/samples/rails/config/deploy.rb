set :application, "swfaddress-sample"
set :repository,  "https://swfaddress.svn.sourceforge.net/svnroot/swfaddress/trunk/swfaddress/samples/rails"

default_run_options[:pty] = true
set :deploy_via, :remote_cache

set :deploy_to, "/var/www/#{application}"

set :user, 'petyo'
set :use_sudo, false
set :deploy, :checkout
ssh_options[:port] = 8654

server 'li-1', :app, :web, :db, :primary => true #this is my server, so change to something else.


#############################################################
#	Passenger
#############################################################

set :rake, '/opt/ruby-enterprise/bin/rake' # Ruby EE.

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
