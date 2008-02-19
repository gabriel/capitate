namespace :centos do 
  
  namespace :ruby do
  
    desc "Install ruby and rubygems"
    task :install do 
    
      ruby_options = {
        :url => "http://capitate.s3.amazonaws.com/ruby-1.8.6-p110.tar.gz",
        :build_dest => "/usr/src",
        :configure_options => "--prefix=/usr",       
        :clean => false, 
        :dependencies => [ "zlib", "zlib-devel" ]
      }
    
      # Install ruby 1.8.6
      script.make_install(ruby_options)
    
      # Fix openssl
      script.sh("ruby/fix_openssl.sh")    
    
      rubygems_options = { 
        :url => "http://rubyforge.org/frs/download.php/29548/rubygems-1.0.1.tgz"
      }
    
      # Install rubygems
      script.install("rubygems", rubygems_options) do 
        sudo "ruby setup.rb > install.log"
      end
    
    end
    
  end
  
end