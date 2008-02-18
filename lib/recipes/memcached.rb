namespace :memcached do
  
  desc "Install memcached monit hooks"
  task :install_monit do
    put template.load("memcached/memcached.monitrc.erb", binding), "/tmp/memcached.monitrc"    
    sudo "install -o root /tmp/memcached.monitrc /etc/monit/memcached.monitrc"
  end
  
end