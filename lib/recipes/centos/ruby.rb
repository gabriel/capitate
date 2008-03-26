namespace :ruby do 
  
  namespace :centos do
  
    desc <<-DESC
    Install ruby and rubygems.
    
    <dl>    
    <dt>ruby_build_options</dt>
    <dd>Ruby build options.</dd>
    
    <dt>rubygems_build_options<dt>
    <dd>Rubygems build options.</dd>    
    </dl>
    
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
    DESC
    task :install do 

      # Settings
      fetch(:ruby_build_options)
      fetch(:rubygems_build_options)
    
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