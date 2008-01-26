namespace :add_user do
  
  # Since the application user does not exist, you will need to log in as an existing user with sudo priviliges.
  # This is known as the bootstrap user.
  #
  # We need to temporarily change the connection user to this bootstrap user, and then set back after.
  # We also need to reset the connection.
  task :setup do
    old_user = fetch(:user)
    
    begin
      new_user = bootstrap_user
      set :user, new_user
      sudo "/usr/sbin/adduser -d #{deploy_to} #{old_user}"
      sudo "chmod a+rx #{deploy_to}"
      
      new_password = Capistrano::CLI.password_prompt("Password for user (#{old_user}): ")
      
      sudo "passwd #{old_user}" do |channel, stream, data|
        logger.info data
        
        if data =~ /password:/i
          channel.send_data "#{new_password}\n"
          channel.send_data "#{new_password}\n"
        end
      end
      
    ensure
      set :user, old_user
    end
    
    clear_sessions
  end
    
end