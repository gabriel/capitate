require File.dirname(__FILE__) + '/test_helper.rb'

class TestPluginUpload < Test::Unit::TestCase
  
  include Capitate::Plugins::Upload

  # Mocked put
  def put(data, dest_path, options)    
    start = 0
    length = 4096
        
    @mock_put << data[start, length]    
  end
  
  # Test upload streamed
  def test_upload
    @mock_put = ""
    
    # Use this file for data
    path = __FILE__
    
    file(path, "mocked")
    
    data = nil
    File.open(__FILE__) { |f| data = f.readlines }
    data = data.join
    
    assert_equal data, @mock_put
  end
  
end

