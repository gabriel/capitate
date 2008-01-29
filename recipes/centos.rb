
namespace :centos do
  
  desc "Install core for centos"
  task :install do
    # Remove lame packages          
    yum_remove([ "openoffice.org-*" ])
    
    # Update all existing packages
    yum_update
    
    # Install core dependencies
    yum_install([ "gcc", "kernel-devel" ])
    
    
    put load_file("centos/sudoers"), "/tmp/sudoers"
    install_script("centos/setup.sh")    
  end
  
  # These run after centos install task and install all the apps
  tasks = [ "ruby:install", "nginx:install", "mongrel_cluster:install", "mysql:install", "sphinx:install", "monit:install", "centos:cleanup" ]
  tasks.each do |task_name|
    after "centos:install", task_name
  end    
    
  desc "Cleanup"
  task :cleanup do
    yum_clean
  end
  
  # Add user for an application
  desc "Add user (adds to admin group)"
  task :add_user_for_app do
    
    with_user(bootstrap_user) do |user_to_add|
    
      exists = false
      sudo "id #{user_to_add}" do |channel, stream, data|
        if data !~ /No such user/
          exists = true
        end
      end
      
      if !exists
    
        sudo "/usr/sbin/adduser -d #{deploy_to} -G admin #{user_to_add}"
        sudo "chmod a+rx #{deploy_to}"
    
        new_password = Capistrano::CLI.password_prompt("Password for user (#{user_to_add}): ")
    
        sudo "passwd #{user_to_add}" do |channel, stream, data|
          logger.info data
      
          if data =~ /password:/i
            channel.send_data "#{new_password}\n"
            channel.send_data "#{new_password}\n"
          end
        end
        
      else        
        logger.important "User #{user_to_add} already exists"
      end
      
    end
        
  end  
            
end