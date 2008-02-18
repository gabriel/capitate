require 'open-uri'

module Capigen::Plugins::Wget
  
  # Download the uri, then upload it into the remote destination directory
  # 
  # ==== Options
  # +uri+:: URI to get
  # +remote_dest_dir+:: Remote destination directory, defaults to /tmp
  #
  def uri(uri, remote_dest_dir = "/tmp")
    
    uri = uri = URI.parse(uri)
    name = uri.path.split("/").last
    remote_dest_path = File.join(remote_dest_dir, name)
    
    logger.info "Downloading #{name} from #{uri}..."      
    put open(uri).read, remote_dest_path    
  end
  
end

Capistrano.plugin :wget, Capigen::Plugins::Wget