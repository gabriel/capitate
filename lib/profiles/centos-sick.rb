set :namespace, "centos"
set :description, "Install based on default centos 5.1 image"

set :recipes, [ 
  "centos:setup_for_web",
  "packages:install",
  "centos:ruby:install", 
  "centos:nginx:install", 
  "nginx:install_monit", 
  "centos:mysql:install", 
  "mysql:install_monit", 
  "centos:sphinx:install", 
  "centos:monit:install",
  "centos:imagemagick:install", 
  "centos:memcached:install", 
  "memcached:install_monit", 
  "gems:install", 
  "centos:cleanup" 
]

#
# Settings for recipes
#

# For packages:install
set :packages_type, :yum
set :packages_remove, [ "openoffice.org-*", "ImageMagick" ]
set :packages_add, [
  "gcc", "kernel-devel", "libevent-devel", "libxml2-devel", 
  "openssl", "openssl-devel",
  "aspell", "aspell-devel", "aspell-en", "aspell-es",
  ]
  
# For gem:install
set :gem_list, [ 
  "rake", 
  "mysql -- --with-mysql-include=/usr/include/mysql --with-mysql-lib=/usr/lib/mysql --with-mysql-config", 
  "raspell", 
  "rmagick", 
  "mongrel", 
  "mongrel_cluster",
  "json"
]

# For monit:install
set :monit_port, 2812 # Capistrano::CLI.ui.ask('Monit port: ')
set :monit_password, Proc.new { Capistrano::CLI.ui.ask('Monit admin password (to set): ') }

# For nginx:install
set :nginx_bin_path, "/sbin/nginx"
set :nginx_conf_path, "/etc/nginx/nginx.conf"
set :nginx_pid_path, "/var/run/nginx.pid"
set :nginx_prefix_path, "/var/nginx"

# For mysql:install
set :mysql_admin_password, Proc.new { Capistrano::CLI.ui.ask('Mysql admin password (to set): ') }
set :mysql_pid_path, "/var/run/mysqld/mysqld.pid"
set :db_port, 3306 # Capistrano::CLI.ui.ask('Mysql port: ')

# For sphinx:install
set :sphinx_prefix, "/usr/local/sphinx"

# For memcached:install
set :memcached_pid_path, "/var/run/memcached.pid"
set :memcached_memory, 64
set :memcached_port, 11211


#
# Settings for generating project Capfile
#

set :application, "sick"
set :user, "sick"
set :deploy_to, "/var/www/apps/sick"
set :web_host, "WEB_HOST"
set :db_host, "DB_HOST"
set :db_pass, ""
set :db_name, "sick"
set :sphinx_host, "SPHINX_HOST"
set :sphinx_port, 3312
set :repository, "REPOSITORY"
set :mongrel_port, 12000
set :mongrel_size, 3
set :domain_name, "localhost"

# Callbacks 

set :before_setup, [ 
  "centos:add_user_for_app" 
]  
set :after_setup, [ 
  "mysql:setup",
  "rails:setup",
  "mongrel_cluster:setup",
  "nginx:setup_mongrel",
  "sphinx:setup"
] 
set :after_update_code, [
  "rails:update_code",
  "sphinx:update_code"
]