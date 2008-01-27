require 'active_support'

$LOAD_PATH.unshift File.dirname(__FILE__) + "/lib"

module Configr; end
module Configr::Helpers; end

require "configr/config_helper"
require "configr/prompt"
require "configr/config"
require "configr/tasks"

require "configr/helpers/yum"
require "configr/helpers/wget"
require "configr/helpers/install_script"

