require File.dirname(__FILE__) + '/test_helper.rb'

class TestRecipes < Test::Unit::TestCase
  
  def test_egrep
    # task :test_egrep do  
    #   role :test, "10.0.6.118", :user => "root"
    # 
    #   found = utils.egrep("^mail.\\*", "/etc/syslog.conf")
    #   puts "Found? #{found}"
    # 
    #   found = utils.egrep("^fooo", "/etc/syslog.conf")
    #   puts "Found? #{found}"
    # end    
    assert true
  end
  
  def test_app
    # task :test_app do  
    #   set :application, "sick"
    #   set :deploy_to, "/var/www/apps/sick"
    #   role :web, "10.0.6.118", :user => "root"
    #   role :app, "10.0.6.118", :user => "root"
    # end
    assert true
  end

  def test_install
    # task :test_install do
    #   load File.dirname(__FILE__) + "/lib/deployment/centos-5.1-64-web/install.rb"
    #   role :test, "10.0.6.118", :user => "root"
    # end
    assert true
  end
  
end

