# Override default deploy tasks here (using Monit). 
# If not using monit, use service start/stop, #sudo "/sbin/service mongrel_cluster_#{application} restart"     
namespace :deploy do
  
  task :restart, :roles => :web do     
    sudo "/usr/local/bin/monit -g mongrel_cluster_#{application} restart all"
  end
  
  task :start, :roles => :web do 
    sudo "/usr/local/bin/monit -g mongrel_cluster_#{application} start all" 
  end
  
  task :stop, :roles => :web do 
    sudo "/usr/local/bin/monit -g mongrel_cluster_#{application} stop all" 
  end
  
end