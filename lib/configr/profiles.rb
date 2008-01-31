module Configr::Profiles
  
  ProfileDir = File.dirname(__FILE__) + "/../../recipes/profiles"
  
  def recipe_profiles(prefix = "")
    Dir[ProfileDir + "/#{prefix}*.yml"].collect { |file| File.basename(file)[0...-4] }  
  end
  
  def choose_profile(prefix = "")
    profile = HighLine.new.choose(*recipe_profiles(prefix)) do |menu|
      menu.header = "Choose recipe profile"
    end
    
    YAML.load_file("#{ProfileDir}/#{profile}.yml")
  end
  
end
    
    