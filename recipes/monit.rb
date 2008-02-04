namespace :monit do
  
  after "monit:install", "monit:install_rc"
  after "monit:install", "monit:install_init"
  after "monit:install", "monit:install_cert"
  
  desc "Install monit"
  task :install do
    package_install([ "flex", "byacc" ])
    script_install("monit/install.sh")      
  end
  
  desc "Install monit RC"
  task :install_rc do
    sudo "mkdir -p /etc/monit"
    
    set :monit_port, Proc.new { Capistrano::CLI.ui.ask('Monit port: ') }
    set :monit_password, Proc.new { Capistrano::CLI.ui.ask('Monit admin password (to set): ') }
  
    put load_template("monit/monitrc.erb", binding), "/tmp/monitrc"
  
    sudo "install -o root -m 700 /tmp/monitrc /etc/monitrc && rm -f /tmp/monitrc"
  end
  
  desc "Install init.d"
  task :install_init do
    
    put load_template("monit/monit.initd.centos.erb", binding), "/tmp/monit.initd"

    sudo "install -o root /tmp/monit.initd /etc/init.d/monit && rm -f /tmp/monit.initd"

    # I don't know if starting from init.d is such a great idea yet
    #sudo "/sbin/chkconfig --level 345 monit on"     
    
    script_install("monit/patch_inittab.sh")
  end
  
  
  desc "Install monit cert"
  task :install_cert do
    sudo "mkdir -p /var/certs"
    
    put load_file("monit/monit.cnf"), "/var/certs/monit.cnf"
    
    script_install("monit/cert.sh")
  end
    
end