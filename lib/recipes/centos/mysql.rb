namespace :mysql do
  
  namespace :centos do
    
    desc <<-DESC
    Install mysql.
    
    *mysql_admin_password_set*: Mysql admin password (to set). _Defaults to password prompt._\n    
    <pre>set :mysql_admin_password_set, prompt.password('Mysql admin password (to set): ')</pre>\n      
    DESC
    task :install do    
      
      # Settings
      fetch_or_default(:mysql_admin_password_set, prompt.password('Mysql admin password (to set): ', :verify => true))

      # Install through package manager
      yum.install([ "mysql", "mysql-devel", "mysql-server" ])

      # Install service
      run_via "/sbin/chkconfig --level 345 mysqld on"
      run_via "/sbin/service mysqld start"
      
      # Set admin password
      run_via "/usr/bin/mysqladmin -u root password #{mysql_admin_password_set}"    
    end
    
  end
  
end