# Centos 5.1 x86_64 with:
# * Ruby
# * Nginx
# * Mysql
# * Sphinx
# * Monit
# * ImageMagick
# * Memcached
# * Gems: rake, mysql, raspell, rmagick, mongrel, mongrel_cluster, json, mime-types, hpricot

namespace :centos_5_1_64_web do

  task :install do
  
    set :user, "root"
    set :run_method, :run
    check_role
      
    # NTP Setup    
    yum.install([ "ntp" ])
    script.run_all <<-CMDS
      chkconfig --levels 235 ntpd on
      ntpdate 0.pool.ntp.org
      /sbin/service ntpd start
    CMDS
  
    # Setup for web  
    # * Add admin group
    # * Change inittab to runlevel 3
    # * Create web apps directory
    # * Add admin group to suders ALL=(ALL)   ALL
    script.run_all <<-CMDS  
      egrep "^admin" /etc/group || /usr/sbin/groupadd admin
      mkdir -p /var/www/apps
      egrep "^%admin" /etc/sudoers || echo "%admin  ALL=(ALL)   ALL" >> /etc/sudoers
    CMDS
    
    # Package installs
    yum.update
    yum.install [ "gcc", "kernel-devel", "libevent-devel", "libxml2-devel", "openssl", "openssl-devel",
       "aspell", "aspell-devel", "aspell-en", "aspell-es" ]
    
    yum.clean
      
    #
    # App installs
    #
      
    ruby.centos.install        
    nginx.centos.install
    mysql.centos.install
    sphinx.centos.install
    
    monit.centos.install
    # Install firewall rule manually
    #monit.centos.iptables 
    
    sshd.monit.install
    
    imagemagick.centos.install
    memcached.centos.install
      
    #
    # Install monit hooks
    #
    nginx.monit.install
    mysql.monit.install
    memcached.monit.install
      
    # Install gems
    gems_only
    
    # Cleanup
    yum.clean
    
    # Log rotate tasks
    monit.logrotate.install
    nginx.logrotate.install
    
  end
  
  desc "Install gems only"
  task :gems_only do
    gems.install(fetch(:gems_to_install))
  end
end

# Prompt for server if host not given
task :check_role do
  # Can use cap HOSTS=192.168.1.111 install
  # Otherwise prompt for the service
  role :install, prompt.ask("Server: ") if find_servers_for_task(current_task).blank?  
end

# For for ruby install
after "ruby:centos:install" do
  # Fix ruby install openssl
  script.sh("ruby/fix_openssl.sh")
end


#
# Install options
#

set :gems_to_install, [ "rake", "mysql -- --with-mysql-include=/usr/include/mysql --with-mysql-lib=/usr/lib/mysql --with-mysql-config", 
  "raspell", "rmagick", "mongrel", "mongrel_cluster", "json", "mime-types", "hpricot" ]


# Ruby install
set :ruby_build_options, {
  :url => "http://capitate.s3.amazonaws.com/ruby-1.8.6-p110.tar.gz",
  :build_dest => "/usr/src",
  :configure_options => "--prefix=/usr",       
  :clean => false
}

set :rubygems_build_options, { 
  :url => "http://rubyforge.org/frs/download.php/29548/rubygems-1.0.1.tgz"
}

# Memcached install
set :memcached_pid_path, "/var/run/memcached.pid"
set :memcached_memory, 64
set :memcached_port, 11211
set :memcached_build_options, {
  :url => "http://www.danga.com/memcached/dist/memcached-1.2.4.tar.gz",
  :configure_options => "--prefix=/usr/local"
}

# Monit install
set :monit_conf_dir, "/etc/monit"
set :monit_pid_path, "/var/run/monit.pid"
set :monit_port, 2812
set :monit_build_options, { 
  :url => "http://www.tildeslash.com/monit/dist/monit-4.10.1.tar.gz" 
}

# Nginx install
set :nginx_bin_path, "/sbin/nginx"
set :nginx_conf_path, "/etc/nginx/nginx.conf"
set :nginx_pid_path, "/var/run/nginx.pid"
set :nginx_prefix_path, "/var/nginx"
set :nginx_build_options, {
  :url => "http://sysoev.ru/nginx/nginx-0.5.35.tar.gz",
  :configure_options => "--sbin-path=#{nginx_bin_path} --conf-path=#{nginx_conf_path} \
--pid-path=#{nginx_pid_path} --error-log-path=/var/log/nginx_master_error.log --lock-path=/var/lock/nginx \
--prefix=#{nginx_prefix_path} --with-md5=auto/lib/md5 --with-sha1=auto/lib/sha1 --with-http_ssl_module \
--with-http_flv_module"
}

# Sphinx install 
set :sphinx_prefix, "/usr/local/sphinx-0.9.8-rc1"
set :sphinx_build_options, {
  :url => "http://www.sphinxsearch.com/downloads/sphinx-0.9.8-rc1.tar.gz",  
  :configure_options => "--with-mysql-includes=/usr/include/mysql --with-mysql-libs=/usr/lib64/mysql --prefix=#{sphinx_prefix}",
  :symlink => { sphinx_prefix => "/usr/local/sphinx" }
}
# Other possible sphinx_build_options
# :url => "http://www.sphinxsearch.com/downloads/sphinx-0.9.7.tar.gz",
# :configure_options => "--with-mysql-includes=/usr/include/mysql --with-mysql-libs=/usr/lib/mysql --prefix=#{sphinx_prefix}",


# For mysql:install
set :mysql_pid_path, "/var/run/mysqld/mysqld.pid"
set :mysql_port, 3306

# Imagemagick install
set :imagemagick_build_options, {
  :url => "http://capitate.s3.amazonaws.com/ImageMagick.tar.gz",
  :unpack_dir => "ImageMagick-*"
}

# For sshd:monit:install
set :sshd_pid_path, "/var/run/sshd.pid"
set :sshd_port, 2023
