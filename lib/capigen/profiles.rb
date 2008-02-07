module Capigen::Profiles
  
  ProfileDir = File.dirname(__FILE__) + "/../profiles"
  
  def recipe_profiles(prefix = "")
    Dir[ProfileDir + "/#{prefix}*.rb"].collect { |file| File.basename(file)[0...-3] }  
  end
  
  def choose_profile(prefix = "")
    profile = HighLine.new.choose(*recipe_profiles(prefix)) do |menu|
      menu.header = "Choose recipe profile"
    end
    
    "#{ProfileDir}/#{profile}.rb"
  end
  
end
    
    