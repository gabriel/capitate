require 'open-uri'

# Wget capistrano helper
module Configr::Helpers::WgetHelper
  
  # Download the uri, then upload it into the remote destination directory
  def wget(uri, remote_dest_dir = "/tmp")
    
    uri = uri = URI.parse(uri)
    name = uri.path.split("/").last
    remote_dest_path = File.join(remote_dest_dir, name)
    
    logger.info "Downloading #{name} from #{uri}..."      
    put open(uri).read, remote_dest_path    
  end
  
end