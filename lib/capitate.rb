require 'rubygems'
require 'active_support'
require 'highline'
require 'capistrano'

HighLine.track_eof = false

# Add this path to ruby load path
$:.unshift File.dirname(__FILE__)

module Capitate # :nodoc:
 module Plugins # :nodoc:
 end  
end

require 'capitate/plugins/base'
require 'capitate/plugins/gem'
require 'capitate/plugins/script'
require 'capitate/plugins/prompt'
require 'capitate/plugins/templates'
require 'capitate/plugins/upload'
require 'capitate/plugins/yum'

# Extensions + Patches
require "capitate/cap_ext/connections"
require "capitate/cap_ext/extension_proxy"
require "capitate/cap_ext/variables"
require "capitate/cap_ext/run_via"
require "capitate/cap_ext/roles"
        
class Capistrano::Configuration   
  include Capitate::CapExt::Variables
  include Capitate::CapExt::RunVia
  include Capitate::CapExt::Roles
  include Capitate::CapExt::Connections
end

#module Capistrano::Configuration::Connections; end

require 'capitate/task_node'

