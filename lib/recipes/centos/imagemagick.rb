namespace :centos do 
  namespace :imagemagick do
  
    task :install do
    
      imagemagick_options = {
        :url => "ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz",
        :unpack_dir => "ImageMagick-*",
        :dependencies => [ "libjpeg-devel", "libpng-devel", "glib2-devel", "fontconfig-devel", "zlib-devel", 
          "libwmf-devel", "freetype-devel", "libtiff-devel" ]
      }
    
      script.make_install("imagemagick", imagemagick_options)
    end
  
  end
end