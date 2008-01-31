namespace :ruby do
  
  desc "Install ruby, rubygems and rake"
  task :install do 
  
    package_install([ "ruby", "ruby-devel", "ruby-libs", "ruby-irb", "ruby-rdoc", "ruby-ri", "zlib", "zlib-devel" ])
    
    # Install ruby 1.8.6
    script_install("ruby/ruby_install.sh")
    
    # Install rubygems
    script_install("ruby/rubygems_install.sh")

    gems = fetch(:gems)
    gem_install(gems) if gems
  end
  
end