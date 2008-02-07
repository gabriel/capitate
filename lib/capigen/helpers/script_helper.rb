# Installer capistrano helper
module Capigen::Helpers::ScriptHelper
  
  def script_install(script, files_to_put = {})
    
    files_to_put.each do |file, dest|
      put load_file(file), dest
    end

    if File.extname(script) == ".erb"
      name = script[0...script.length-4]
      dest = "/tmp/#{name}"
      run "mkdir -p #{File.dirname(dest)}"
      put load_template(script, binding), dest   
      
    else
      name = script
      dest = "/tmp/#{name}"
      run "mkdir -p #{File.dirname(dest)}"
      put load_file(name), dest
    end
    
    # If want verbose, -v
    sudo "sh #{dest}"
    
    # Cleanup
    sudo "rm -rf #{File.dirname(dest)}"    
  end
  
end