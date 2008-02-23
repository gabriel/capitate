# Custom tasks for centos OS profiles
namespace :centos do

  # Add user for an application
  desc <<-DESC
  Add user and set user password for application. Adds user to specified groups. 
  
  *user*: User to add
  
  @set :user, "app_user"@
  
  *groups*: Groups for user to be in. _Defaults to none_
  
  @set :groups, "admin,foo"@
  
  *home*: Home directory for user. _Defaults to <tt>:deploy_to</tt> setting_
  
  @set :home, "/var/www/apps/app_name"@
  
  *home_readable*: Whether home permissions are readable by all. Needed if using deploy dir as home. _Defaults to true_
  
  @set :home_readable, true@
    
  DESC
  task :add_user do
    
    # Settings
    fetch(:user)
    fetch_or_default(:groups, nil)
    fetch_or_default(:home, deploy_to)
    fetch_or_default(:home_readable, true)
    
    # Need to be root because we don't have any other users at this point
    install_user = "root"
    
    with_user(install_user) do
      
      adduser_options = []
      adduser_options << "-d #{home}" unless home.blank?
      adduser_options << "-G #{groups}" unless groups.blank?
    
      run "id sick || /usr/sbin/adduser #{adduser_options.join(" ")} #{user}"
            
      run "chmod a+rx #{home}" if home_readable
  
      new_password = prompt.password("Password for user (#{user}): ", true)
  
      run "passwd #{user}" do |channel, stream, data|
        logger.info data
    
        if data =~ /password:/i
          channel.send_data "#{new_password}\n"
          channel.send_data "#{new_password}\n"
        end
      end
      
    end
        
  end
              
end