namespace :mysql do
  
  namespace :centos do
    
    desc <<-DESC
    Install mysql.
    
    *mysql_admin_password_set*: Mysql admin password (to set). _Defaults to password prompt._
    
    @set :mysql_admin_password_set, prompt.password('Mysql admin password (to set): ')@
      
    DESC
    task :install do    
      
      # Settings
      fetch_or_default(:mysql_admin_password_set, prompt.password('Mysql admin password (to set): '))

      # Install through package manager
      yum.install([ "mysql", "mysql-devel", "mysql-server" ])

      # Install service
      sudo "/sbin/chkconfig --level 345 mysqld on"
      sudo "/sbin/service mysqld start"
      
      # Set admin password
      sudo "/usr/bin/mysqladmin -u root password #{mysql_admin_password_set}"    
    end
    
  end
  
end