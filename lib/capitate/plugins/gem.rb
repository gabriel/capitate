module Capitate::Plugins::Gem
  
  # Install a gem.
  #
  # ==== Options
  # +gems+:: List of gem names, or a single gem
  #
  # ==== Examples (in capistrano task)
  #   gemc.install("raspell") 
  #   gemc.install([ "raspell", "foo" ])
  #
  def install(gems)
    # If a single object, wrap in array
    gems = [ gems ] unless gems.is_a?(Array)
    
    # Install one at a time because we may need to pass install args (e.g. mysql)
    # TODO: Fix this
    gems.each do |gem|
      sudo "gem install --no-rdoc --no-ri --no-verbose #{gem}"
    end
  end
  
end

Capistrano.plugin :gemc, Capitate::Plugins::Gem