namespace :monit do
  
  desc "Install monit"
  task :install do
    # Dependencies: "flex", "byacc"
    
    put load_template("monit/monit.initd.centos.erb", binding), "/tmp/monit.initd"
    put load_template("monit/monitrc.erb", binding), "/tmp/monitrc"
    put load_file("monit/monit.cnf"), "/tmp/monit.cnf"
    
    script_install("monit/install.sh")      
    script_install("monit/patch_inittab.sh")
    script_install("monit/cert.sh")
  end
      
end