#
# This is an EXAMPLE deployment script based on some recipes in Capitate.
#

#
# For installing apps on the thoughpolice centos 5.1 image
#
task :install do
  
  # Set templates dir to this here gem
  # You probably want to change this
  set :templates_dirs, [ File.dirname(__FILE__) + "/templates", File.dirname(__FILE__) + "/../templates" ]
  
  set :user, "root"
  set :run_method, :run
  
  # Use cap HOSTS=192.168.1.111 install
  # Otherwise prompt for the service
  role :install, prompt.ask("Server: ") if find_servers_for_task(current_task).blank?
  
  # Setup for web  
  script.sh("setup_for_web.sh")
  
  # Install sudoers
  put template.load("sudoers"), "/tmp/sudoers"
  run "install -o root -m 440 /tmp/sudoers /etc/sudoers && rm -f /tmp/sudoers"  
  
  # Package installs
  yum.remove [ "openoffice.org-*", "ImageMagick" ]
  yum.update
  yum.install [ "gcc", "kernel-devel", "libevent-devel", "libxml2-devel", "openssl", "openssl-devel",
     "aspell", "aspell-devel", "aspell-en", "aspell-es" ]
  
  # App installs
  ruby.centos.install
  nginx.centos.install
  mysql.centos.install
  sphinx.centos.install
  monit.centos.install
  imagemagick.centos.install
  memcached.centos.install
  
  # Install monit hooks
  nginx.install_monit
  mysql.install_monit

  # Gem installs
  gems.install([ "rake", "mysql -- --with-mysql-include=/usr/include/mysql --with-mysql-lib=/usr/lib/mysql --with-mysql-config", 
    "raspell", "rmagick", "mongrel", "mongrel_cluster","json" ])

  # Cleanup
  yum.clean
end


# For monit:install
set :monit_port, 2812

# For nginx:install
set :nginx_bin_path, "/sbin/nginx"
set :nginx_conf_path, "/etc/nginx/nginx.conf"
set :nginx_pid_path, "/var/run/nginx.pid"
set :nginx_prefix_path, "/var/nginx"

# For mysql:install
set :mysql_pid_path, "/var/run/mysqld/mysqld.pid"
set :db_port, 3306

# For sphinx:install
set :sphinx_prefix, "/usr/local/sphinx"

# For memcached:install
set :memcached_pid_path, "/var/run/memcached.pid"
set :memcached_memory, 64
set :memcached_port, 11211


