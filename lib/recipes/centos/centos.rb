# Custom tasks for centos OS profiles
namespace :centos do

  # Add user for an application
  desc <<-DESC
  Add user and set user password for application. Adds user to specified groups. 
  
  *user_add*: User to add.\n
  @set :user_add, "app_user"@
  *groups*: Groups for user to be in. _Defaults to none_\n
  @set :groups, "admin,foo"@\n
  *home*: Home directory for user. _Defaults to <tt>:deploy_to</tt> setting_\n
  @set :home, "/var/www/apps/app_name"@\n
  *home_readable*: Whether home permissions are readable by all. Needed if using deploy dir as home. _Defaults to true_\n
  @set :home_readable, true@\n
  DESC
  task :add_user do
    
    # Settings
    fetch(:user_add)
    fetch_or_default(:groups, nil)
    fetch_or_default(:home, deploy_to)
    fetch_or_default(:home_readable, true)
    
    adduser_options = []
    adduser_options << "-d #{home}" unless home.blank?
    adduser_options << "-G #{groups}" unless groups.blank?
  
    user_existed = false
    run "id #{user_add} || /usr/sbin/adduser #{adduser_options.join(" ")} #{user_add}" do |channel, stream, data|
      logger.info data
      user_existed = data =~ /uid/
    end
    
    logger.info "User already existed, aborting..." if user_existed
    
    unless user_existed
      run "chmod a+rx #{home}" if home_readable
  
      new_password = prompt.password("Password to set for #{user_add}: ", :verify => true, :lazy => false)
  
      run "passwd #{user_add}" do |channel, stream, data|
        logger.info data
  
        if data =~ /password:/i
          channel.send_data "#{new_password}\n"
          channel.send_data "#{new_password}\n"
        end
      end
    end
        
  end
              
end