namespace :centos do
  
  namespace :mysql do
    
    desc "Install mysql"
    task :install do    
      
      # Settings
      fetch(:mysql_admin_password_set, 
        Proc.new { Capistrano::CLI.ui.ask('Mysql admin password (to set): ') })      

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