load 'deploy' if respond_to?(:namespace) # cap2 differentiator

load "recipes/bootstrap/patch.rb"

# Load recipes
Dir['recipes/*.rb'].each { |plugin| load(plugin) }

require 'erb'

# This should be overriden by project specific Capfile
set :user, Proc.new { Capistrano::CLI.ui.ask('Bootstrap user: ') }

# Roles
role :app, Capistrano::CLI.ui.ask('Server: ')
