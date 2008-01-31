namespace :ruby do
  
  desc "Install ruby, rubygems and rake"
  task :install do 
  
    yum_install([ "ruby", "ruby-devel", "ruby-libs", "ruby-irb", "ruby-rdoc", "ruby-ri", "zlib", "zlib-devel" ])
    
    # Install ruby 1.8.6
    install_script("ruby/ruby_install.sh")
    
    # Install rubygems
    install_script("ruby/rubygems_install.sh")
  
    # Gems to install
    sudo "gem install rake"    
  end
  
end