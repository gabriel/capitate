# Gem capistrano helpers
module Configr::Helpers::GemHelper
  
  # gem_install("raspell") or gem_install([ "raspell", "foo" ])
  def gem_install(gems)
    # If a single object, wrap in array
    gems = [ gems ] unless gems.is_a?(Array)
    
    sudo "gem install --no-rdoc --no-ri --no-verbose #{gems.join(" ")}"
  end
  
end