namespace :ruby do 
  
  namespace :centos do
  
    desc <<-DESC
    Install ruby and rubygems.
    
    *ruby_build_options*: Ruby build options.\n
    *rubygems_build_options*: Rubygems build options.\n
    DESC
    task :install do 

      # Settings
      fetch(:ruby_build_options)
      fetch(:rubygems_build_options)
    
      # Install dependencies
      yum.install([ "zlib", "zlib-devel", "readline-devel" ])
    
      # Install ruby 1.8.6
      script.make_install("ruby", ruby_build_options)
    
      # Install rubygems
      script.install("rubygems", rubygems_build_options) do |dir|
        run_via "cd #{dir} && ruby setup.rb > install.log", { :shell => true }
      end
    
    end        
    
  end
  
end