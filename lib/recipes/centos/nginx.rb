namespace :nginx do 
  
  namespace :centos do
    
    desc <<-DESC
    Install nginx, conf, initscript, nginx user and service.
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:nginx_build_options, <<-EOS)
    Nginx build options.
    <pre>
    <code class="ruby">
    set :nginx_build_options, {
      :url => "http://sysoev.ru/nginx/nginx-0.5.35.tar.gz",
      :configure_options => "--sbin-path=\#{nginx_bin_path} --conf-path=\#{nginx_conf_path}
        --pid-path=\#{nginx_pid_path} --error-log-path=/var/log/nginx_master_error.log --lock-path=/var/lock/nginx 
        --prefix=\#{nginx_prefix_path} --with-md5=auto/lib/md5 --with-sha1=auto/lib/sha1 --with-http_ssl_module"
    }
    </code>
    </pre>
    EOS
    task_arg(:nginx_bin_path, "Nginx sbin path", :default => "/sbin/nginx")
    task_arg(:nginx_conf_path, "Path to nginx conf", :default => "/etc/nginx/nginx.conf")
    task_arg(:nginx_pid_path, "Path to nginx pid file", :default => "/var/run/nginx.pid")
    task_arg(:nginx_prefix_path, "Nginx install prefix", :default => "/var/nginx")          
    task :install do      
      # Install dependencies
      yum.install([ "pcre-devel", "openssl", "openssl-devel" ]) 
            
      # Build
      build.make_install("nginx", nginx_build_options)

      # Initscript
      initscript

      # Setup nginx
      run_via "mkdir -p /etc/nginx/vhosts"
      run_via "echo \"# Blank nginx conf; work-around for nginx conf include issue\" > /etc/nginx/vhosts/blank.conf"
      put template.load("nginx/nginx.conf.erb", binding), "/tmp/nginx.conf"
      run_via "install -o root -m 644 /tmp/nginx.conf #{nginx_conf_path} && rm -f /tmp/nginx.conf"

      # Create nginx user
      run_via "id nginx || /usr/sbin/adduser -r nginx"
    end
    
    desc "Install nginx initscript"
    task_arg(:nginx_bin_path, "Nginx sbin path", :default => "/sbin/nginx")
    task_arg(:nginx_conf_path, "Path to nginx conf", :default => "/etc/nginx/nginx.conf")
    task_arg(:nginx_pid_path, "Path to nginx pid file", :default => "/var/run/nginx.pid")    
    task :initscript do
      utils.install_template("nginx/nginx.initd.centos.erb", "/etc/init.d/nginx")
      run_via "/sbin/chkconfig --level 345 nginx on"
    end
    
    # Restart nginx
    desc "Restart nginx (service)"
    task :restart do
      sudo "/sbin/service nginx restart"
    end    
    
  end
  
end