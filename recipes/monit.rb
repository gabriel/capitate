namespace :monit do
  
  desc "Install monit"
  task :install do
    yum_install([ "flex", "byacc" ])
    install_script("monit/install.sh")    
  end
  
end