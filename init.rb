require 'active_support'

$LOAD_PATH.unshift File.dirname(__FILE__) + "/lib"

module Configr; end
module Configr::Helpers; end
module Configr::Packagers; end

require "configr/packagers/yum"

require "configr/helpers/package_helper"
require "configr/helpers/wget_helper"
require "configr/helpers/script_helper"
require "configr/helpers/gem_helper"
require "configr/templates"
require "configr/profiles"
require "configr/config_helper"

require "configr/config"
require "configr/tasks"
