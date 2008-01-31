# Override default deploy tasks here.
# TODO: Use monit to restart if included.
namespace :deploy do
  
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