namespace :gems do
  
  desc "Install gems from profile"
  task :install_manual do
    profile = choose_profile    
    gems = profile["gems"]
    gem_install(gems) if gems    
  end
  
  desc "Install gems"
  task :install do
    gems = fetch(:gems)
    gem_install(gems) if gems
  end
  
end