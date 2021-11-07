-- load configuration modules

local plugins = require("plugins")
local plugin_loader = require("plugin-loader").init()
plugin_loader:load(plugins)

require("plug-settings-loader")
require("settings")
require("mappings.global")
