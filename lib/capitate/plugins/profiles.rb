# == Profiles
# Useful for starting a profile, but your mileage may vary.
#
module Capitate::Plugins::Profiles
  
  ProfileDir = File.dirname(__FILE__) + "/../../profiles"
  
  # Load all profiles with prefix.
  #
  # ==== Options
  # +prefix+:: Prefix to filter/search on
  #  
  def list(prefix = "")
    Dir[ProfileDir + "/#{prefix}*.rb"].collect { |file| File.basename(file).gsub(File.extname(file), "") }
  end
  
  # Choose a profile (via command line).
  # 
  # ==== Options
  # +prefix+:: Prefix to filter/search on
  #
  def choose(prefix = "")
    profile = HighLine.new.choose(*list(prefix)) do |menu|
      menu.header = "Choose recipe profile"
    end
    
    "#{ProfileDir}/#{profile}.rb"
  end

end
    
    
Capistrano.plugin :profile, Capitate::Plugins::Profiles