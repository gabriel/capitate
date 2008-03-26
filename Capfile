#
# Capfile for running base install recipe
#

load 'deploy' if respond_to?(:namespace) # cap2 differentiator

require 'lib/capitate'

# Load recipes
require 'lib/capitate/recipes'

require 'erb'

# Test
task :test_egrep do  
  role :test, "10.0.6.118", :user => "root"
  
  found = utils.egrep("^mail.\\*", "/etc/syslog.conf")
  puts "Found? #{found}"
  
  found = utils.egrep("^fooo", "/etc/syslog.conf")
  puts "Found? #{found}"
end

task :test_app do  
  set :application, "sick"
  set :deploy_to, "/var/www/apps/sick"
  role :web, "10.0.6.118", :user => "root"
  role :app, "10.0.6.118", :user => "root"
end

task :test_install do
  load File.dirname(__FILE__) + "/lib/deployment/centos-5.1-64-web/install.rb"
  role :test, "10.0.6.118", :user => "root"
end
