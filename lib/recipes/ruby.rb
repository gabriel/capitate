namespace :ruby do
  
  desc "Install ruby and rubygems"
  task :install do 
    # Dependencies: zlib, zlib-devel
    
    # Install ruby 1.8.6
    script.install("ruby/ruby_install.sh")
    
    # Install rubygems
    script.install("ruby/rubygems_install.sh")
  end
  
end