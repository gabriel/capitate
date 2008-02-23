#
# Capfile for running base install recipe
#

load 'deploy' if respond_to?(:namespace) # cap2 differentiator

require 'lib/capitate'

# Load recipes
require 'lib/capitate/recipes'

require 'erb'

set :user, "root"

# For testing
load "lib/deployment/install-centos-rubyweb.rb"
