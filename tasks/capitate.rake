namespace :capitate do
  
  task :bootstrap do
    
    include Capitate::Plugins::Templates    
    write("capistrano/Capfile", binding, "Capfile")    
    
  end
  
end