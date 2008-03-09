module Capitate::Plugins::Gem
  
  # Install a gem.
  #
  # ==== Options
  # +gems+:: List of gem names, or a single gem
  #
  # ==== Examples (in capistrano task)
  #   gems.install("raspell") 
  #   gems.install([ "raspell", "foo" ])
  #
  def install(gems)
    # If a single object, wrap in array
    gems = [ gems ] unless gems.is_a?(Array)
    
    # Install one at a time because we may need to pass install args (e.g. mysql)
    gems.each do |gem|
      run_via "gem install --no-rdoc --no-ri --no-verbose #{gem}"
    end
  end
  
end

Capistrano.plugin :gems, Capitate::Plugins::Gem