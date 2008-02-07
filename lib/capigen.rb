require 'active_support'
require 'highline'
require 'capistrano'

HighLine.track_eof = false

$:.unshift File.dirname(__FILE__)

module Capigen
 module Helpers
 end  
 
 module Packagers
 end
end

require "capigen/packagers/yum"

require "capigen/helpers/package_helper"
require "capigen/helpers/wget_helper"
require "capigen/helpers/script_helper"
require "capigen/helpers/gem_helper"
require "capigen/templates"
require "capigen/profiles"
require "capigen/helper"

require "capigen/config"

require "capigen/cap_ext/configuration"
require "capigen/cap_ext/namespace"
require "capigen/cap_ext/connections"
        


