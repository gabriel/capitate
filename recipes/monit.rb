namespace :monit do
  
  desc "Install monit"
  task :install do
    package_install([ "flex", "byacc" ])
    script_install("monit/install.sh")    
  end
  
end