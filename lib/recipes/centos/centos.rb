# Custom tasks for centos OS profiles
namespace :centos do
    
  desc "Setup centos for web"
  task :setup_for_web do
    put template.load("centos/sudoers"), "/tmp/sudoers"
    script.sh("centos/setup_for_web.sh")
  end  
    
  desc "Cleanup"
  task :cleanup do
    yum.clean
    # TODO: Add cleanup tasks here
  end
  
  # Add user for an application
  desc "Add user (adds to admin group)"
  task :add_user_for_app do
    
    # Settings
    user = fetch(:user)
    fetch_or_default(:install_user, "root")
    
    with_user(install_user) do
    
      sudo "id sick || /usr/sbin/adduser -d #{deploy_to} -G admin #{user}"
      sudo "chmod a+rx #{deploy_to}"
  
      new_password = Capistrano::CLI.password_prompt("Password for user (#{user}): ")
  
      sudo "passwd #{user}" do |channel, stream, data|
        logger.info data
    
        if data =~ /password:/i
          channel.send_data "#{new_password}\n"
          channel.send_data "#{new_password}\n"
        end
      end
      
    end
        
  end
              
end