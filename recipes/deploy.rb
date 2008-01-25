# Override default deploy tasks here
namespace :deploy do
  
  task :install, :roles => :web do
    # No default
  end
  
  task :restart, :roles => :web do 
    sudo "/sbin/service mongrel_cluster_#{application} restart" 
  end
  
  task :start, :roles => :web do 
    sudo "/sbin/service mongrel_cluster_#{application} start" 
  end
  
  task :stop, :roles => :web do 
    sudo "/sbin/service mongrel_cluster_#{application} stop" 
  end
  
end