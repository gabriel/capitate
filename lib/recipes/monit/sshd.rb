namespace :sshd do
  
  namespace :monit do
    
    desc <<-DESC
    Install sshd monit hooks.
  
    *sshd_port*: SSH daemon port. _Defaults to 22_\n
    *sshd_pid_path*: Path to mysql pid file. _Defaults to /var/run/sshd.pid_\n
    *monit_conf_dir*: Destination for monitrc. _Defaults to "/etc/monit"_\n
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :install do
    
      # Settings 
      fetch_or_default(:sshd_port, 3306)   
      fetch_or_default(:sshd_pid_path, "/var/run/sshd.pid")      
      fetch_or_default(:monit_conf_dir, "/etc/monit") 
    
      put template.load("sshd/sshd.monitrc.erb", binding), "/tmp/sshd.monitrc"    
      run_via "install -o root /tmp/sshd.monitrc #{monit_conf_dir}/sshd.monitrc"
    end
    
  end
  
end