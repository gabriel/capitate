module Capitate::Plugins::Upload
  
  # Upload file with source path.
  #
  # Data is streamed.
  #
  # ==== Options
  # +src_path+:: Source path
  # +dest_path+:: Remote destination path
  # +options+:: Options (see capistrano 'put')
  #
  # ==== Examples
  #   upload.file("/tmp/large_file.tgz", "#{shared_path}/tmp/large_file.tgz")
  #
  def file(src_path, dest_path, options = {})
    data = FileData.new(src_path)
    put(data, dest_path, options)    
  end
    
  # Stream data with Net::SFTP by looking like an Array
  class FileData
    
    def initialize(path)
      @path = path
      @next_start = 0
    end
    
    def [](start, length)
      
      if start != @next_start
        raise <<-EOS
        
        Can only access data sequentially; so we can stream it (The next start position should have been: #{@next_start})
        
        EOS
      end
      
      data = file.read(length)
      
      @next_start = start + length
      close if @next_start >= self.length
        
      data
    end
    
    def length
      @file_size ||= File.size(@path)
    end
    
    def file
      @file ||= File.open(@path, "r")
    end
    
    def close
      @file.close if @file
    end
    
  end
  
end
  
Capistrano.plugin :upload, Capitate::Plugins::Upload