module Capigen::Plugins::Script
  
  # Install (sh) script
  #
  # ==== Options
  # +script+:: Name of file (relative to templates dir) 
  # +files_to_put+:: List of files to upload [ { :file => "foo/bar.txt", :dest "/tmp/bar.txt" }, ... ]
  #
  def install(script, files_to_put = [], override_binding = nil)
    
    files_to_put = [ files_to_put ] if files_to_put.is_a?(Hash)
    
    files_to_put.each do |file_info|
      data = template.load(file_info[:file], override_binding || binding)
      put data, file_info[:dest]
    end
    
    if File.extname(script) == ".erb"
      name = script[0...script.length-4]
      dest = "/tmp/#{name}"
      run "mkdir -p #{File.dirname(dest)}"
      put template.load(script, override_binding || binding), dest
    else
      name = script
      dest = "/tmp/#{name}"
      run "mkdir -p #{File.dirname(dest)}"
      put template.load(script), dest
    end
    
    # If want verbose, -v
    sudo "sh #{dest}"
    
    # Cleanup
    sudo "rm -rf #{File.dirname(dest)}"    
  end
  
end

Capistrano.plugin :script, Capigen::Plugins::Script