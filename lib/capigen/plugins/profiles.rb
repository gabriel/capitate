module Capigen::Plugins::Profiles
  
  ProfileDir = File.dirname(__FILE__) + "/../../profiles"
  
  # Load all profile recipes with prefix.
  #
  # ==== Options
  # +prefix+:: Prefix to filter/search on
  #  
  def recipes(prefix = "")
    Dir[ProfileDir + "/#{prefix}*.rb"].collect { |file| File.basename(file).gsub(File.extname(file), "") }
  end
  
  # Choose a profile (via command line).
  # 
  # ==== Options
  # +prefix+:: Prefix to filter/search on
  #
  def choose(prefix = "")
    profile = HighLine.new.choose(*recipes(prefix)) do |menu|
      menu.header = "Choose recipe profile"
    end
    
    "#{ProfileDir}/#{profile}.rb"
  end
  
  # Fetch the profile, see local gem Capfile for implementation details.
  def ask
    fetch(:profile)
  end
  
  # Fetch and raise useful error if value is not set.
  #
  # ===== Options
  # +var+:: Variable to fetch
  # +message+:: Raise custom message (like usage info)
  #  
  def get(var, message = nil)
    begin
      result = fetch(var.to_sym)
    rescue
      if message.blank?
        message = <<-EOS
      
        Please set :#{var} variable in your Capfile or profile.
      
        EOS
      end
      
      raise "\n#{message}"
    end
    result
  end
  
  # Fetch and return default if value not set.
  #
  # ==== Options
  # +var+:: Variable to fetch
  # +default+:: Result to return if variable not set
  #
  def get_or_default(var, default)
    begin
      result = fetch(var.to_sym)
    rescue
      result = default
    end
    result
  end
  
end
    
    
Capistrano.plugin :profile, Capigen::Plugins::Profiles