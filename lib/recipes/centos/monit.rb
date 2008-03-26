namespace :monit do
  
  namespace :centos do

    desc <<-DESC
    Install monit.
    
    <dl>
    <dt>monit_build_options</dt>
    <dd>Monit build options.</dd>
    
    <pre>
    <code class="ruby">
    set :monit_build_options, { :url => "http://www.tildeslash.com/monit/dist/monit-4.10.1.tar.gz" }
    </code>
    </pre>

    <dt>monit_port</dt>
    <dd>Monit port</dd>
    <dd class="default">Defaults to @2812@</dd>
    <dd>@set :monit_port, 2812@</dd>

    <dt>monit_password</dt>
    <dd>Monit password</dd>
    <dd class="default">Defaults to password prompt</dd>
    <dd>@set :monit_password, prompt.password('Monit admin password (to set): ')@</dd>

    <dt>monit_conf_dir</dt><dd>Directory for monitrc files.</dd>
    <dd>@set :monit_conf_dir, "/etc/monit"@</dd>

    <dt>monit_pid_path</dt><dd>Path to monit pid.</dd>
    @set :monit_pid_path, "/var/run/monit.pid"@</dd>

    <dt>monit_log_path</dt>
    <dd>Path to monit log file.</dd>
    <dd class="default">Defaults to @/var/log/monit.log@</dd>
    
    </dl>
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :install do
      
      # Settings
      fetch_or_default(:monit_port, 2812)
      fetch_or_default(:monit_password, prompt.password('Monit admin password (to set): ', :verify => true))
      fetch_or_default(:monit_conf_dir, "/etc/monit")
      fetch_or_default(:monit_pid_path, "/var/run/monit.pid")
      fetch_or_default(:monit_log_path, "/var/log/monit.log")
      fetch(:monit_build_options)
        
      # Install dependencies
      yum.install([ "flex", "byacc" ])
        
      # Build
      #build.make_install("monit", monit_build_options)

      # Install initscript
      utils.install_template("monit/monit.initd.centos.erb", "/etc/init.d/monit")

      # Install monitrc
      run_via "mkdir -p /etc/monit"
      utils.install_template("monit/monitrc.erb", "/etc/monitrc", :user => "root", :mode => "700")      

      # Build cert
      run_via "mkdir -p /var/certs"
      utils.install_template("monit/monit.cnf", "/var/certs/monit.cnf")
      
      script.run_all <<-CMDS
        openssl req -new -x509 -days 365 -nodes -config /var/certs/monit.cnf -out /var/certs/monit.pem -keyout /var/certs/monit.pem -batch > /var/certs/debug_req.log 2>&1
        openssl gendh 512 >> /var/certs/monit.pem 2> /var/certs/debug_gendh.log
        openssl x509 -subject -dates -fingerprint -noout -in /var/certs/monit.pem > /var/certs/debug_x509.log
        chmod 700 /var/certs/monit.pem
      CMDS
      
      # Install to inittab
      utils.append_to("/etc/inittab", <<-APPEND, "^mo:345:respawn:/usr/local/bin/monit")
       
        # Run monit in standard run-levels
        mo:345:respawn:/usr/local/bin/monit -Ic /etc/monitrc -l #{monit_log_path} -p #{monit_pid_path}
      APPEND
      
      # HUP the inittab
      run_via "telinit q"
    end
    
    desc <<-DESC
    Install monit firewall rule.
    
    *monit_port*: Monit port. _Defaults to 2812_\n    
    @set :monit_port, 2812@\n
    DESC
    task :iptables do
      # Settings
      fetch_or_default(:monit_port, 2812)      
      run_via "iptables -A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport #{monit_port} -j ACCEPT"
      run_via "/sbin/service iptables save"
    end
    
  end
  
end