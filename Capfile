#
# Capfile for running base install recipe
#

load 'deploy' if respond_to?(:namespace) # cap2 differentiator

require 'lib/capitate'

# Load recipes
require 'lib/capitate/recipes'

require 'erb'


set :recipes_run, [ "centos:setup_for_web", "packages:install", "ruby:centos:install" ]
set :user, "root"
