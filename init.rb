require 'active_support'

$LOAD_PATH.unshift File.dirname(__FILE__) + "/lib"

module Configr; end

require "configr/config_helper"
require "configr/prompt"
require "configr/config"
require "configr/tasks"

