namespace :centos do
  
  task :install do      
    
    yum_remove([ "openoffice.org-*" ])
    yum_update
    yum_install([ "gcc", "kernel-devel" ])
    sudo "mkdir -p /var/www/apps"
  
  end
  
  task :cleanup do
    yum_clean
  end
      
end