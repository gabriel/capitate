namespace :capitate do
  
  task :generate do
    
    profile.ask
    
    template.project("capistrano/Capfile"), "Capfile"

    
  end
  
end