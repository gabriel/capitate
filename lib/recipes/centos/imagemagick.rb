namespace :imagemagick do 
  namespace :centos do
  
    desc <<-DESC
    Install imagemagick.\n    
    <dl><dt>imagemagick_build_options</dt><dd>Imagemagick build options</dd></dl>
    <pre>
    <code class="ruby">
    set :imagemagick_build_options, {
      :url => "ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz",
      :unpack_dir => "ImageMagick-*"
    }
    </code>
    </pre>
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :install do
      
      # Settings 
      fetch(:imagemagick_build_options)
      
      # Install dependencies
      yum.install([ "libjpeg-devel", "libpng-devel", "glib2-devel", "fontconfig-devel", "zlib-devel", 
        "libwmf-devel", "freetype-devel", "libtiff-devel" ])
        
      build.make_install("imagemagick", imagemagick_build_options)
    end
  
  end
end