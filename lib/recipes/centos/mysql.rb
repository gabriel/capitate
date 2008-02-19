namespace :centos do
  
  namespace :mysql do
    
    desc "Install mysql"
    task :install do    
      
      # Settings
      fetch_or_default(:mysql_admin_password, 
        Proc.new { Capistrano::CLI.ui.ask('Mysql admin password (to set): ') })      

      # Install through package manager
      package.install([ "mysql", "mysql-devel", "mysql-server" ])

      # Install service
      sudo "/sbin/chkconfig --level 345 mysqld on"
      sudo "/sbin/service mysqld start"
      
      # Set admin password
      sudo "/usr/bin/mysqladmin -u root password #{mysql_admin_password}"    
    end
    
  end
  
end