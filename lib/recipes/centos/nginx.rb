namespace :centos do 
  
  namespace :nginx do
    
    desc "Install nginx, conf, initscript, nginx user and service"
    task :install do
      
      # Settings
      nginx_bin_path = profile.get_or_default(:nginx_bin_path, "/sbin/nginx")
      nginx_conf_path = profile.get_or_default(:nginx_conf_path, "/etc/nginx/nginx.conf")
      nginx_pid_path = profile.get_or_default(:nginx_pid_path, "/var/run/nginx.pid")
      nginx_prefix_path = profile.get_or_default(:nginx_prefix_path, "/var/nginx")      
      
      # Build options
      nginx_options = {
        :url => "http://sysoev.ru/nginx/nginx-0.5.35.tar.gz",
        :configure_options => "--sbin-path=#{nginx_bin_path} --conf-path=#{nginx_conf_path} \
--pid-path=#{nginx_pid_path} --error-log-path=/var/log/nginx_master_error.log --lock-path=/var/lock/nginx \
--prefix=#{nginx_prefix_path} --with-md5=auto/lib/md5 --with-sha1=auto/lib/sha1 --with-http_ssl_module",
        :dependencies => [ "pcre-devel", "openssl", "openssl-devel" ]
      }

      # Build
      script.make_install("nginx", nginx_options)

      # Install initscript, and turn it on
      put template.load("nginx/nginx.initd.erb", binding), "/tmp/nginx.initd"
      sudo "install -o root /tmp/nginx.initd /etc/init.d/nginx && rm -f /tmp/nginx.initd"
      sudo "/sbin/chkconfig --level 345 nginx on"

      # Setup nginx
      sudo "mkdir -p /etc/nginx/vhosts"
      sudo "echo \"# Blank nginx conf; work-around for nginx conf include issue\" > /etc/nginx/vhosts/blank.conf"
      put template.load("nginx/nginx.conf.erb", binding), "/tmp/nginx.conf"
      sudo "install -o root -m 644 /tmp/nginx.conf #{nginx_conf_path} && rm -f /tmp/nginx.conf"

      # Create nginx user
      sudo "id nginx || /usr/sbin/adduser -r nginx"
    end
    
  end
  
end