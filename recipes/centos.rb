
namespace :centos do
  
  desc "Install core for centos"
  task :install do
    # Remove lame packages          
    yum_remove([ "openoffice.org-*" ])
    
    # Update all existing packages
    yum_update
    
    # Install core dependencies
    yum_install([ "gcc", "kernel-devel" ])
    
    # Create web apps directory
    sudo "mkdir -p /var/www/apps"       
    
    # Add admin group
    sudo "/usr/sbin/groupadd admin"
    
    # Patch sudoers to include admin group
    put load_file("patches/centos/sudoers.patch"), "/tmp/sudoers.patch"
    sudo "patch /etc/sudoers < /tmp/sudoers.patch" 
    
    # Change inittab to runlevel 3
    sudo "sed -i -e 's/^id:5:initdefault:/id:3:initdefault:/g' /etc/inittab"
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