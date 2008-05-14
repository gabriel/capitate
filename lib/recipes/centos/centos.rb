# Custom tasks for centos OS profiles
namespace :centos do

  # Add user for an application
  desc <<-DESC
  Add user and set user password for application. Adds user to specified groups. 
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:user_add, "User to add")
  task_arg(:groups, "Groups for user to be in", :default => nil, :example => "\"admin,foo,bar\"")
  task_arg(:home, "Home directory for user", :set => :deploy_to)
  task_arg(:home_readable, "Whether home permissions are readable by all. Needed if using deploy dir as home.", :default => true)
  task :add_user do
    
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