require File.dirname(__FILE__) + '/test_helper.rb'
require 'capistrano/configuration'

class TestRoles < Test::Unit::TestCase
  
  def setup
    @config = Capistrano::Configuration.new
  end
  
  def test_fetch
    
    @config.load do
    
      role :test, "10.0.6.20"
      role :test_with_options, "10.0.6.21", :op1 => true
      role :test_with_options, "10.0.6.22", :op2 => true
      
      role :test_with_other_options, "10.0.6.23", :sphinx_port => 3312
    
    end
    
    test_role = @config.fetch_role(:test)
    
    assert test_role
    assert_equal "10.0.6.20", test_role.host
    
    test_roles = @config.fetch_roles(:test_with_options)
    assert test_roles
    assert_equal [ "10.0.6.21", "10.0.6.22" ], test_roles.collect(&:host)
        
    test_roles_with_opts = @config.fetch_roles(:test_with_options, :op1 => true)
    assert test_roles_with_opts
    assert_equal [ "10.0.6.21" ], test_roles_with_opts.collect(&:host)    
    
    test_role_with_opts = @config.fetch_role(:test_with_options, :op2 => true)
    assert test_role_with_opts
    assert_equal "10.0.6.22", test_role_with_opts.host
    
    
    test_role_with_other_opts = @config.fetch_role(:test_with_other_options)
    assert test_role_with_other_opts
    assert_equal "10.0.6.23", test_role_with_other_opts.host
    assert_equal 3312, test_role_with_other_opts.options[:sphinx_port]
    
  end
  
end