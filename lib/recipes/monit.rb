namespace :monit do
  
  desc "Install monit"
  task :install do
    # Dependencies: "flex", "byacc"
    
    install_files = [ 
      { :file => "monit/monit.initd.centos.erb", :dest => "/tmp/monit.initd" },
      { :file => "monit/monitrc.erb", :dest => "/tmp/monitrc" } 
    ]
    
    script.install("monit/install.sh", install_files)  
        
    script.install("monit/patch_inittab.sh")
    
    script.install("monit/cert.sh", :file => "monit/monit.cnf", :dest => "/tmp/monit.cnf")
  end
      
end