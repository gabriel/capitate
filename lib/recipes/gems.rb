namespace :gems do
  
  desc "Install gems"
  task :install do        
    # Settings
    fetch(:gem_list)
    
    gemc.install(gem_list)
  end
  
end