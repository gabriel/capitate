#
# Settings for project
#

set :application, "sick"
set :user, "sick"
set :groups, "admin"

set :deploy_to, "/var/www/apps/sick"
set :web_host, "192.168.1.111"
set :db_host, "192.168.1.111"
set :db_user, "sick"
set :db_pass, prompt.password("DB Password: ")
set :db_name, "sick"
set :repository, "http://svn.ducktyper.com/scratch/testapp/trunk"
set :mongrel_port, 12000
set :mongrel_size, 3
set :domain_name, "localhost"
set :mysql_admin_password, prompt.password('Mysql admin password: ')

set :deploy_via, :copy
set :copy_strategy, :export

role :web, "192.168.1.111"
role :db, "192.168.1.111", :primary => true


# Callbacks 
before "deploy:setup", "centos:add_user"

after "deploy:setup", "mysql:setup", "rails:setup", "mongrel_cluster:centos:setup",
  "nginx:setup_mongrel", "sphinx:centos:setup"
  
after "sphinx:centos:setup", "sphinx:setup_monit"
after "mongrel_cluster:centos:setup", "mongrel_cluster:setup_monit"

after "nginx:setup_mongrels", "nginx:centos:restart"

after "deploy:update_code", "rails:update_code", "sphinx:update_code"

# Auto cleanup after deploy
after "deploy", "deploy:cleanup"