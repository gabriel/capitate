namespace :gems do
  
  desc <<-DESC    
    Install gems.
    
      set :gem_list, [ 
        "rake", 
        "mysql -- --with-mysql-include=/usr/include/mysql --with-mysql-lib=/usr/lib/mysql --with-mysql-config",
        "raspell"
      ]
      
  DESC
  task :install do        
    # Settings
    fetch(:gem_list)
    
    gemc.install(gem_list)
  end
  
end