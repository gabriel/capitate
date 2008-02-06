namespace :memcached do
  
  desc "Install memcached"
  task :install do
    put load_template("memcached/memcached.initd.centos.erb", binding), "/tmp/memcached.initd"    
    script_install("memcached/install.sh")   
  end

  desc "Install memcached monit hooks"
  task :install_monit do
    put load_template("memcached/memcached.monitrc.erb", binding), "/tmp/memcached.monitrc"    
    script_install("memcached/install_monit.sh")    
  end
  
end