namespace :imagemagick do 
  namespace :centos do
  
    desc <<-DESC
    Install imagemagick.
    
    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:imagemagick_build_options, <<-EOS)
    Imagemagick build options
    <pre>
    <code class="ruby">
    set :imagemagick_build_options, {
      :url => "ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz",
      :unpack_dir => "ImageMagick-*"
    }
    </code>
    </pre>
    EOS
    task :install do      
      # Install dependencies
      yum.install([ "libjpeg-devel", "libpng-devel", "glib2-devel", "fontconfig-devel", "zlib-devel", 
        "libwmf-devel", "freetype-devel", "libtiff-devel" ])
        
      build.make_install("imagemagick", imagemagick_build_options)
    end
  
  end
end