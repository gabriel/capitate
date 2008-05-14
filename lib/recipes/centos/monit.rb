namespace :monit do
  
  namespace :centos do

    desc <<-DESC
    Install monit.
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:monit_port, "Monit port", :default => 2812)
    task_arg(:monit_password, "Monit password", :default => Proc.new{prompt.password('Monit admin password (to set): ', :verify => true)}, :default_desc => "password prompt")
    task_arg(:monit_conf_dir, :default => "/etc/monit")
    task_arg(:monit_pid_path, "Path to monit pid", :default => "/var/run/monit.pid")
    task_arg(:monit_log_path, "Path to monit log file", :default => "/var/log/monit.log")
    task_arg(:monit_build_options, <<-EOS)    
    Monit build options
    <pre>
    <code class="ruby">
    set :monit_build_options, { :url => "http://www.tildeslash.com/monit/dist/monit-4.10.1.tar.gz" }
    </code>
    </pre>
    EOS
    task :install do
      
      # Install dependencies
      yum.install([ "flex", "byacc" ])
        
      # Build
      build.make_install("monit", monit_build_options)

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
        
  end
  
end