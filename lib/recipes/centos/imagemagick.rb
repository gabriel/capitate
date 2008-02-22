namespace :imagemagick do 
  namespace :centos do
  
    desc "Install imagemagick"
    task :install do
      
      # Install dependencies
      yum.install([ "libjpeg-devel", "libpng-devel", "glib2-devel", "fontconfig-devel", "zlib-devel", 
        "libwmf-devel", "freetype-devel", "libtiff-devel" ])
    
      imagemagick_options = {
        :url => "ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz",
        :unpack_dir => "ImageMagick-*"
      }
    
      script.make_install("imagemagick", imagemagick_options)
    end
  
  end
end