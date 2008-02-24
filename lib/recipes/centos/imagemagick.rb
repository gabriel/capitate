namespace :imagemagick do 
  namespace :centos do
  
    desc <<-DESC
    Install imagemagick.\n    
    *imagemagick_build_options*: Imagemagick build options.
    DESC
    task :install do
      
      # Settings 
      fetch(:imagemagick_build_options)
      
      # Install dependencies
      yum.install([ "libjpeg-devel", "libpng-devel", "glib2-devel", "fontconfig-devel", "zlib-devel", 
        "libwmf-devel", "freetype-devel", "libtiff-devel" ])
        
      script.make_install("imagemagick", imagemagick_build_options)
    end
  
  end
end