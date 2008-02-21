require File.dirname(__FILE__) + '/test_helper.rb'

class TestTemplates < Test::Unit::TestCase
  
  TmpDir = File.dirname(__FILE__) + "/tmp"

  def setup
    FileUtils.mkdir(TmpDir)
  end
  
  def teardown
    FileUtils.rm_rf(TmpDir)
  end

  def test_write    
    TemplatesPlugin.write("capistrano/Capfile", "#{TmpDir}/Capfile")
    
    lines = ""
    File.open("#{TmpDir}/Capfile") { |f| lines = f.readlines }
    assert lines.length > 0
  end
  
end

class TemplatesPlugin
  class << self
    include Capitate::Plugins::Templates  
  end
end
