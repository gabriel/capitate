namespace :monit do
  
  namespace :centos do

    desc <<-DESC
    Install monit.
    
    *monit_build_options*: Monit build options.\n
    @set :monit_build_options, { :url => "http://www.tildeslash.com/monit/dist/monit-4.10.1.tar.gz" }@\n
    *monit_port*: Monit port. _Defaults to 2812_\n    
    @set :monit_port, 2812@\n
    *monit_password*: Monit password. _Defaults to password prompt_\n    
    @set :monit_password, prompt.password('Monit admin password (to set): ')@\n    
    *monit_conf_dir*: Directory for monitrc files.\n    
    @set :monit_conf_dir, "/etc/monit"@\n      
    *monit_pid_path*: Path to monit pid.\n
    @set :monit_pid_path, "/var/run/monit.pid"@\n
    DESC
    task :install do
      
      # Settings
      fetch_or_default(:monit_port, 2812)
      fetch_or_default(:monit_password, prompt.password('Monit admin password (to set): ', :verify => true))
      fetch_or_default(:monit_conf_dir, "/etc/monit")
      fetch_or_default(:monit_pid_path, "/var/run/monit.pid")
      fetch(:monit_build_options)
        
      # Install dependencies
      yum.install([ "flex", "byacc" ])
        
      # Build
      build.make_install("monit", monit_build_options)

      # Install initscript
      put template.load("monit/monit.initd.centos.erb"), "/tmp/monit.initd"
      run_via "install -o root /tmp/monit.initd /etc/init.d/monit && rm -f /tmp/monit.initd"

      # Install monitrc
      put template.load("monit/monitrc.erb"), "/tmp/monitrc"
      run_via "mkdir -p #{monit_conf_dir} && install -o root -m 700 /tmp/monitrc /etc/monitrc && rm -f /tmp/monitrc"

      # Patch initab
      script.sh("monit/patch_inittab.sh")

      # Build cert
      put template.load("monit/monit.cnf"), "/tmp/monit.cnf"
      script.sh("monit/cert.sh")
    end
    
  end
  
end