module Capitate::Plugins::Utils
  
  # Symlink source to dest
  #
  # ==== Options
  # +args+:: Arguments. If argument is hash, then key is symlinked to value.
  #
  # ==== Examples
  #   ln("src/foo" => "dest/foo") # Run: ln -nfs src/foo dest/foo
  #
  def ln(*args)    
    args.each do |arg|
      if arg.is_a?(Hash)
        arg.each do |src, dest|
          run_via "ln -nfs #{src} #{dest}"    
        end    
      end
    end
  end
  
  def install_template(template_path, destination)
    put template.load("memcached/memcached.monitrc.erb"), "/tmp/memcached.monitrc"    
    run_via "install -o root /tmp/memcached.monitrc #{monit_conf_dir}/memcached.monitrc"
  end
  
end

Capistrano.plugin :utils, Capitate::Plugins::Utils