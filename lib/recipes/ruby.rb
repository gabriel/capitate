namespace :ruby do
  
  desc "Install ruby and rubygems"
  task :install do 
    # Dependencies: zlib, zlib-devel
    
    # Install ruby 1.8.6
    script_install("ruby/ruby_install.sh")
    
    # Install rubygems
    script_install("ruby/rubygems_install.sh")
  end
  
end