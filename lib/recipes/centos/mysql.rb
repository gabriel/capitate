namespace :mysql do
  
  namespace :centos do
    
    desc <<-DESC
    Install mysql.
    
    <dl>
    <dt>mysql_admin_password_set</dt>
    <dd>Mysql admin password (to set)</dd>
    <dd class="default">Defaults to password prompt.</dd>    
    <pre><code class="ruby">set :mysql_admin_password_set, prompt.password('Mysql admin password (to set): ')<code></pre>
    </dl>
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :install do    
      
      # Settings
      fetch_or_default(:mysql_admin_password_set, prompt.password('Mysql admin password (to set): ', :verify => true))

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