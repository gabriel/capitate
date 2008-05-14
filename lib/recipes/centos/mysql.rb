namespace :mysql do
  
  namespace :centos do
    
    desc <<-DESC
    Install mysql.
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:mysql_admin_password_set, "Mysql admin password (to set)", :default => Proc.new{prompt.password('Mysql admin password (to set): ', :verify => true)}, :default_desc => "password prompt")
    task :install do    
      # Install through package manager
      yum.install([ "mysql", "mysql-devel", "mysql-server" ])

      # Install service
      run_via "/sbin/chkconfig --level 345 mysqld on"
      run_via "/sbin/service mysqld restart"
      
      # Set admin password
      run_via "/usr/bin/mysqladmin -u root password #{mysql_admin_password_set}"    
    end
    
  end
  
end