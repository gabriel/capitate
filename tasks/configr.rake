require File.dirname(__FILE__) + "/../init"

namespace :configr do 
  
  # Create Capfile and deploy.rb
  task :setup do     
    include Configr::Tasks
    task_setup
  end
  
  # Remove capistrano files
  task :clean do
    include Configr::Tasks
    task_clean
  end
    
  # Create configr yaml config
  task :bootstrap do
    include Configr::Tasks
    task_bootstrap
  end
  
end