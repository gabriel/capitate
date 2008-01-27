namespace :ruby do
  
  desc "Install ruby, rubygems and rake"
  task :install do 
  
    yum_install([ "ruby", "ruby-devel", "ruby-libs", "ruby-irb", "ruby-rdoc", "ruby-ri", "zlib", "zlib-devel" ])
    
    # Install rubygems
    install_script("ruby/rubygems_install.sh")
  
    # Gems to install
    sudo "gem install rake"
    
  end
  
end