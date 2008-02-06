set :namespace, "centos"
set :description, "Install based on thoughtpolice centos 5.1 image"
set :packager_type, "yum" 
set :packages_to_remove, [ "openoffice.org-*", "ImageMagick" ]
set :packages_to_add, [ 
  "gcc", "kernel-devel", "libevent-devel", "libxml2-devel", 
  "openssl", "openssl-devel",
  "aspell", "aspell-devel", "aspell-en", "aspell-es",
  "zlib", "zlib-devel", 
  "gcc-c++", 
  "pcre-devel", 
  "mysql", "mysql-devel", "mysql-server",
  "flex", "byacc", 
  "libjpeg-devel", "libpng-devel", "glib2-devel", "fontconfig-devel", "libwmf-devel", "freetype-devel",
    "libtiff-devel"
]
  
set :install_tasks, [ 
  #"centos:setup", 
  #"ruby:install", 
  #"nginx:install", 
  #"nginx:install_monit", 
  #"mysql:install", 
  #"mysql:install_monit", 
  #"sphinx:install", 
  "monit:install",
  "imagemagick:install", 
  "memcached:install", 
  "memcached:install_monit", 
  "gems:install", 
  "centos:cleanup" 
]

set :gems, [ 
  "rake", 
  "mysql -- --with-mysql-include=/usr/include/mysql --with-mysql-lib=/usr/lib/mysql --with-mysql-config", 
  "raspell", "rmagick", "mongrel", "mongrel_cluster" 
]

# Monit
set :monit_port, 2812 # Capistrano::CLI.ui.ask('Monit port: ')
set :monit_password, Capistrano::CLI.ui.ask('Monit admin password (to set): ') 

# For nginx
set :nginx_bin_path, "/sbin/nginx"
set :nginx_conf_path, "/etc/nginx/nginx.conf"
set :nginx_pid_path, "/var/run/nginx.pid"
set :nginx_prefix_path, "/var/nginx"

# Mysql
set :mysql_admin_password, Capistrano::CLI.ui.ask('Mysql admin password (to set): ')
set :mysql_pid_path, "/var/run/mysqld/mysqld.pid"
set :db_port, 3306 # Capistrano::CLI.ui.ask('Mysql port: ')

# Sphinx
set :sphinx_prefix, "/usr/local/sphinx"

# Memcached
set :memcached_pid_path, "/var/run/memcached.pid"
set :memcached_memory, 64
set :memcached_port, 11211



