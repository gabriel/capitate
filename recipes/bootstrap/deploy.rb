#
# Patches
#

class Capistrano::Configuration::Namespaces::Namespace
  
  # Load config helper for use within recipes
  require File.dirname(__FILE__) + "/../../init"
  include Configr::ConfigHelper
  include Configr::Helpers::Yum
  include Configr::Helpers::Wget
      
end

class Capistrano::Configuration
  # Load config helper for use within Capfile
  require File.dirname(__FILE__) + "/../../init"
  include Configr::ConfigHelper

end


# Patch to add ability to clear sessions
module Capistrano::Configuration::Connections
  
  def with_user(new_user, &block)
    old_user = fetch(:user)
    
    begin
      set :user, new_user
      yield      
    ensure
      set :user, old_user
    end
    
    clear_sessions
  end
  
  def clear_sessions
    logger.info "Clearing sessions..."
    @sessions = {}
  end
  
end


#
# Deploy.rb (from config yaml)
#

config = load_config_yaml

set :application, config["application"]
set :repository, config["repository"]

set :deploy_via, :copy
set :copy_strategy, :export
set :user, config["user"]

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, config["deploy_to"]

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :web, config["web_server"]
role :db,  config["db_server"], :primary => true

# set :keep_releases, 3
# set :use_sudo, false

#
# Custom variables accessible in recipes
#
vars = [ :db_user, :db_pass, :db_name, :mongrel_port, :mongrel_size, :domain_name, :web_server ]
vars.each do |var|
  set var, config[var.to_s]
end

set :mysql_admin_user, Proc.new { Capistrano::CLI.ui.ask('Mysql admin user: ') }
# Could use Capistrano::CLI.password_prompt("...")
set :mysql_admin_password, Proc.new { Capistrano::CLI.ui.ask('Mysql admin password: ') } 

set :bootstrap_user, Proc.new { Capistrano::CLI.ui.ask('Bootstrap user: ') }

#
# Capfile
# 

capfile_callbacks.each do |callback|
  before callback[:deploy_task], callback[:recipe_callback] if callback[:when] == :before
  after callback[:deploy_task], callback[:recipe_callback] if callback[:when] == :after
end
