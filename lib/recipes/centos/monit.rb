namespace :monit do
  
  namespace :centos do

    desc <<-DESC
    Install monit.
    
    *monit_port*: Monit port. _Defaults to 2812_
    
    @set :monit_port, 2812@

    *monit_password*: Monit password. _Defaults to password prompt_
    
    @set :monit_password, prompt.password('Monit admin password (to set): ')@
    
    *monit_conf_dir*: Directory for monitrc files.
    
    @set :monit_conf_dir, "/etc/monit"@
      
    DESC
    task :install do
      
      # Settings
      fetch_or_default(:monit_port, 2812)
      fetch_or_default(:monit_password, prompt.password('Monit admin password (to set): ', true))
      fetch_or_default(:monit_conf_dir, "/etc/monit")
        
      # Install dependencies
      yum.install([ "flex", "byacc" ])
        
      # Build options
      monit_options = {
        :url => "http://www.tildeslash.com/monit/dist/monit-4.10.1.tar.gz"
      }

      # Build
      script.make_install("monit", monit_options)

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