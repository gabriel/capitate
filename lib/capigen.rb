require 'active_support'
require 'highline'
require 'capistrano'

HighLine.track_eof = false

$:.unshift File.dirname(__FILE__)

module Capigen # :nodoc:
 module Plugins # :nodoc:
 end  
end

require 'capigen/plugins/base'
require 'capigen/plugins/gem'
require 'capigen/plugins/package'
require 'capigen/plugins/profiles'
require 'capigen/plugins/script'
require 'capigen/plugins/templates'
require 'capigen/plugins/wget'
require 'capigen/plugins/yum'

require "capigen/config"

require "capigen/cap_ext/connections"
require "capigen/cap_ext/extension_proxy"
        


