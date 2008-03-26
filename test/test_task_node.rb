require File.dirname(__FILE__) + '/test_helper.rb'

class TestTaskNode < Test::Unit::TestCase
  
  def test_find_source    
    file, source, comments = Capitate::TaskNode.find_source("backgroundrb:setup")    
    #puts "Source: #{source}"
    
    file, source, comments = Capitate::TaskNode.find_source("backgroundrb:update_code")    
    #puts "Source: #{source}"    
  end
  
  def test_find_source_deploy
    file, source, comments = Capitate::TaskNode.find_source("deploy")    
    puts "Source: #{source}"
  end
  
end
