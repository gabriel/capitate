namespace :gems do
  
  desc "Install gems"
  task :install do    
    gem_list = profile.get(:gem_list, <<-EOS)
    
      To use this recipe, set the :gem_list variable (in a profile, Capfile or deploy.rb), for example:
      
      set :gem_list, [ 
        "rake", 
        "mysql -- --with-mysql-include=/usr/include/mysql --with-mysql-lib=/usr/lib/mysql --with-mysql-config", 
        "raspell" 
      ]
    
    EOS
    
    gemc.install(gem_list)
  end
  
end