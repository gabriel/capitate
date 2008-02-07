module Capigen::Plugins::Package
  
  # Setup packager
  #
  # ==== Options
  # +packager+:: Packager type (:yum)
  #
  def type=(packager_type)
    case packager_type.to_sym
    when :yum
      include Capigen::Plugins::Yum
    else
      raise "Invalid packager type: #{packager_type}"
    end    
  end
    
end

Capistrano.plugin :package, Capigen::Plugins::Package