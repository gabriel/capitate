module Capigen::Plugins::Profiles
  
  ProfileDir = File.dirname(__FILE__) + "/../../profiles"
  
  def recipes(prefix = "")
    Dir[ProfileDir + "/#{prefix}*.rb"].collect { |file| File.basename(file).gsub(File.extname(file), "") }
  end
  
  def choose(prefix = "")
    profile = HighLine.new.choose(*recipes(prefix)) do |menu|
      menu.header = "Choose recipe profile"
    end
    
    "#{ProfileDir}/#{profile}.rb"
  end
  
  # More helpful fetch
  def get(var)
    begin
      result = fetch(var.to_sym)
    rescue
      puts <<-EOS
      
      Please set :#{var} variable in your Capfile or profile.
      
      EOS
      raise "Please set :#{var} in your Capfile or profile."
    end
    result
  end
  
end
    
    
Capistrano.plugin :profile, Capigen::Plugins::Profiles