namespace :nginx do 
  
  namespace :centos do
    
    desc <<-DESC
    Install nginx, conf, initscript, nginx user and service.
    
    <dl>
    <dt>nginx_build_options</dt>
    <dd>Nginx build options.
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
    </dd>
    
    <dt>nginx_bin_path</dt>
    <dd>Nginx sbin path</dd>
    <dd class="default">Defaults to /sbin/nginx</dd>
    <dd>@set :nginx_bin_path, "/sbin/nginx"@</dd>
    
    <dt>nginx_conf_path</dt>
    <dd>Path to nginx conf.</dd>
    <dd class="default">Defaults to /etc/nginx/nginx.conf</dd>
    <dd>@set :nginx_conf_path, "/etc/nginx/nginx.conf"@</dd>
    
    <dt>nginx_pid_path</dt>
    <dd>Path to nginx pid file</dd>
    <dd class="default">Defaults to /var/run/nginx.pid</dd>
    <dd>@set :nginx_pid_path, "/var/run/nginx.pid"@</dd>
    
    <dt>nginx_prefix_path</dt>
    <dd>Nginx install prefix</dd>
    <dd class="default">Defaults to /var/nginx_</dd>
    <dd>@set :nginx_prefix_path, "/var/nginx"@</dd>
    </dl>
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :install do
      
      # Settings
      fetch(:nginx_build_options)
      fetch_or_default(:nginx_bin_path, "/sbin/nginx")
      fetch_or_default(:nginx_conf_path, "/etc/nginx/nginx.conf")
      fetch_or_default(:nginx_pid_path, "/var/run/nginx.pid")
      fetch_or_default(:nginx_prefix_path, "/var/nginx")      
            
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
    task :initscript do
      fetch_or_default(:nginx_bin_path, "/sbin/nginx")
      fetch_or_default(:nginx_conf_path, "/etc/nginx/nginx.conf")
      fetch_or_default(:nginx_pid_path, "/var/run/nginx.pid")
      
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