namespace :ruby do 
  
  namespace :centos do
  
    desc <<-DESC
    Install ruby and rubygems.
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:ruby_build_options, <<-EOS)
    Rubygems build options.
    <pre>
    <code class="ruby">
    set :ruby_build_options, {
      :url => "http://capitate.s3.amazonaws.com/ruby-1.8.6-p110.tar.gz",
      :build_dest => "/usr/src",
      :configure_options => "--prefix=/usr",       
      :clean => false
    }
    </code>
    </pre>
    EOS
    task_arg(:rubygems_build_options, "Rubygems build options")    
    task :install do 
      # Install dependencies
      yum.install([ "zlib", "zlib-devel", "readline-devel" ])
    
      # Install ruby 1.8.6
      build.make_install("ruby", ruby_build_options)
    
      # Install rubygems
      build.install("rubygems", rubygems_build_options) do |dir|
        run_via "cd #{dir} && ruby setup.rb"
      end
    
    end        
    
  end
  
end