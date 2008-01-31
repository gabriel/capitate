namespace :aspell do
  
  task :install do
    
    package_install([ "aspell", "aspell-devel", "aspell-en", "aspell-es" ])
    
  end
  
end