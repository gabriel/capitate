# Gem capistrano helpers
module Capigen::Helpers::GemHelper
  
  # gem_install("raspell") or gem_install([ "raspell", "foo" ])
  def gem_install(gems)
    # If a single object, wrap in array
    gems = [ gems ] unless gems.is_a?(Array)
    
    # Install one at a time because we may need to pass install args (e.g. mysql)
    gems.each do |gem|
      sudo "gem install --no-rdoc --no-ri --no-verbose #{gem}"
    end
  end
  
end