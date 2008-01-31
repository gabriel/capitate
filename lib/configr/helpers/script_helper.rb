# Installer capistrano helper
module Configr::Helpers::ScriptHelper
  
  def install_script(script, files_to_put = {})
    
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
    
    sudo "sh -v #{dest}"
  end
  
end