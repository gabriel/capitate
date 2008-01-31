
namespace :centos do
  
  
  desc "Install core for centos"
  task :install do
    
    profile = choose_profile
    
    # These run after centos install task and install all the apps
    profile["tasks"].each do |task_name|
      after "centos:install", task_name
    end
    
    # Remove packages          
    yum_remove(profile["packages"]["remove"])
    
    # Update all existing packages
    yum_update
    
    # Install packages
    yum_install(profile["packages"]["install"])
    
    # Setup    
    install_script("centos/setup.sh",  { "centos/sudoers" => "/tmp/sudoers" })    
  end
    
  desc "Cleanup"
  task :cleanup do
    yum_clean
  end
  
  # Add user for an application
  desc "Add user (adds to admin group)"
  task :add_user_for_app do
    
    with_user(bootstrap_user) do |user_to_add|
    
      sudo "id sick || /usr/sbin/adduser -d #{deploy_to} -G admin #{user_to_add}"
      sudo "chmod a+rx #{deploy_to}"
  
      new_password = Capistrano::CLI.password_prompt("Password for user (#{user_to_add}): ")
  
      sudo "passwd #{user_to_add}" do |channel, stream, data|
        logger.info data
    
        if data =~ /password:/i
          channel.send_data "#{new_password}\n"
          channel.send_data "#{new_password}\n"
        end
      end
      
    end
        
  end  
            
end