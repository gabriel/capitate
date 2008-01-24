require 'test/unit'
require 'rubygems'
require 'active_support'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

RAILS_ROOT = '.' unless defined?(RAILS_ROOT)

require 'rake'
Dir[File.dirname(__FILE__) + "/../tasks/*.rake"].each { |task| load task }