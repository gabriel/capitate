namespace :aspell do
  
  task :install do
    
    yum_install([ "aspell", "aspell-devel", "aspell-en", "aspell-es" ])
    
  end
  
end