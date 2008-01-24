require File.dirname(__FILE__) + "/test_helper.rb"
require 'fileutils'

class ConfigTest < Test::Unit::TestCase
  
  Files = [ "Capfile", "config/deploy.rb" ]
  
  # Remove generated files
  def teardown
   FileUtils.rm_rf(Files.collect { |f| File.dirname(__FILE__) + "/#{f}" })    
  end
  
  def from_root(path)
    File.join(RAILS_ROOT, path)
  end
  
  # Test setting up capistrano
  def test_setup_capistrano
    Rake::Task["configr:setup"].invoke        
    
    assert File.exist?("Capfile")
    assert File.exist?("config/deploy.rb")
    
    clean_capistrano
  end
  
  # Test clean
  def clean_capistrano    
    Rake::Task["configr:clean"].invoke    
    
    assert !File.exist?("Capfile")
    assert !File.exist?("config/deploy.rb")
  end
  
end