namespace :install do
  
  set :profile, nil
  
  task :default do
    # TODO: This sucks (mostly capistrano's fault)
    profile = fetch(:profile) 
    profile = choose_profile unless profile
    set :profile, profile 
    set :gems, profile["gems"]
    
    packager_type = profile["packager"]["type"]
    packages_to_remove = profile["packager"]["remove"]
    packages_to_add = profile["packager"]["install"]
    tasks = profile["tasks"]
    namespace = profile["namespace"]
    
    # Setup packager
    setup_packager(packager_type)
    
    # Remove packages          
    package_remove(packages_to_remove)
    
    # Update all existing packages
    package_update
    
    # Install packages
    package_install(packages_to_add)
    
    # These run after install task and install all the apps
    tasks.each do |task_name|
      after "install", task_name
    end
  end
  
end