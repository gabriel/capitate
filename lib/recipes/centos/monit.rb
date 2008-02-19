namespace :centos do
  
  namespace :monit do

    desc "Install monit"
    task :install do
      
      # Settings
      fetch_or_default(:monit_port, 2812)
      fetch_or_default(:monit_password, 
        Proc.new { Capistrano::CLI.ui.ask('Monit admin password (to set): ') })

      # Build options
      monit_options = {
        :url => "http://www.tildeslash.com/monit/dist/monit-4.10.1.tar.gz",
        :dependencies => [ "flex", "byacc" ]      
      }

      # Build
      script.make_install("monit", monit_options)

      # Install initscript
      put template.load("monit/monit.initd.centos.erb"), "/tmp/monit.initd"
      sudo "install -o root /tmp/monit.initd /etc/init.d/monit && rm -f /tmp/monit.initd"

      # Install monitrc
      put template.load("monit/monitrc.erb"), "/tmp/monitrc"
      sudo "mkdir -p /etc/monit && install -o root -m 700 /tmp/monitrc /etc/monitrc && rm -f /tmp/monitrc"

      # Patch initab
      script.sh("monit/patch_inittab.sh")

      # Build cert
      put template.load("monit/monit.cnf"), "/tmp/monit.cnf"
      script.sh("monit/cert.sh")
    end

  end
  
end