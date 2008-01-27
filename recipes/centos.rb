namespace :centos do
  
  task :install do

    with_user(bootstrap_user) do
      
      yum_update
      
      # Remove
      yum_remove([ "openoffice.org-*" ])
      
      # Install 
      yum_install([ "gcc", "kernel-devel", "gcc-c++" ])
      yum_install([ "ruby", "ruby-devel", "ruby-libs", "ruby-irb", "ruby-rdoc", "ruby-ri", "zlib", "zlib-devel" ])
      yum_install([ "pcre-devel", "openssl", "openssl-devel" ])
      yum_install([ "mysql", "mysql-devel", "mysql-server" ])
      yum_install([ "flex", "byacc" ])
      
      # Install rubygems
      wget "http://rubyforge.org/frs/download.php/29548/rubygems-1.0.1.tgz"
      run "cd /tmp && tar zxpf rubygems-1.0.1.tgz"
      sudo "cd /tmp/rubygems-1.0.1 && ruby setup.rb"
    
      # Gems to install
      sudo "gem install rake"
      
      # Create www apps dir
      sudo "mkdir -p /var/www/apps"
    
    end
  end
    
end