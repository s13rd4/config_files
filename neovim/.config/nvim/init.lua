-- load configuration modules

local plugins = require("sierda.plugins")
local plugin_loader = require("sierda.plugin-loader").init()
plugin_loader:load(plugins)

require("sierda.plug-settings-loader")
require("sierda.settings")
require("sierda.mappings-loader")
