namespace :gems do
  
  desc "Install gems"
  task :install do    
    gem_list = profile.get(:gem_list)
    
    gemc.install(gem_list)
  end
  
end