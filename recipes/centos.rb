# Tasks for centos OS profiles
namespace :centos do
    
  desc "Install centos profile"
  task :install do    
    set :profile, choose_profile("centos")
    after "centos:install", "install:default"
  end
    
  desc "Cleanup"
  task :cleanup do
    package_clean
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
  
  desc "Sudoers"
  task :install_sudoers do    
    put load_file("centos/sudoers"), "/tmp/sudoers"
    script_install("centos/setup.sh")
  end
            
end