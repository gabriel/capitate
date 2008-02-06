#
# Capfile for running base install recipe
#

load 'deploy' if respond_to?(:namespace) # cap2 differentiator

# Patches for capistrano
load "recipes/bootstrap/patch.rb"

# Load recipes
Dir['recipes/*.rb'].each { |plugin| load(plugin) }

require 'erb'

# This should be overriden by project specific Capfile
set :user, Proc.new { Capistrano::CLI.ui.ask('Bootstrap user: ') }

# Roles
role :base, Capistrano::CLI.ui.ask('Server: ')


set :profile, Proc.new { load choose_profile }