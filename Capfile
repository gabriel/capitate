#
# Capfile for running base install recipe
#

load 'deploy' if respond_to?(:namespace) # cap2 differentiator

require 'lib/capitate'

# Load recipes
Dir["lib/recipes/**/*.rb"].each { |recipe| load recipe }

require 'erb'

# This should be overriden by project specific Capfile
set :user, Proc.new { Capistrano::CLI.ui.ask('Bootstrap user: ') }

# Roles
role :base, Capistrano::CLI.ui.ask('Server: ')

# Choose a profile
set :profile, Proc.new { load profile.choose }

# Reset the password var
reset_password