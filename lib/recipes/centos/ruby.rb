namespace :ruby do 
  
  namespace :centos do
  
    desc "Install ruby and rubygems"
    task :install do 
    
      # Install dependencies
      yum.install([ "zlib", "zlib-devel" ])
    
      ruby_options = {
        :url => "http://capigen.s3.amazonaws.com/ruby-1.8.6-p110.tar.gz",
        :build_dest => "/usr/src",
        :configure_options => "--prefix=/usr",       
        :clean => false
      }
    
      # Install ruby 1.8.6
      script.make_install("ruby", ruby_options)
    
      # Fix openssl
      script.sh("ruby/fix_openssl.sh")    
    
      rubygems_options = { 
        :url => "http://rubyforge.org/frs/download.php/29548/rubygems-1.0.1.tgz"
      }
    
      # Install rubygems
      script.install("rubygems", rubygems_options) do |dir|
        sudo "echo 'Running setup...' && cd #{dir} && ruby setup.rb > install.log"
      end
    
    end
    
  end
  
end