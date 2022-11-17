M = {}
--[[
local function scandir(directory)
    local t, popen = {}, io.popen
    local pfile = popen('find "'..directory..'" -type f')
    for filename in pfile:lines() do
		local noext = string.gsub(filename,".lua","")
		local nopre = string.gsub(noext,"/",".")
        table.insert(t,nopre)
    end
    pfile:close()
    return t
end

local settings = scandir("plug-settings")
]]

local settings = {

	"sierda.plug-settings.material",
	"sierda.plug-settings.gitsings",
	"sierda.plug-settings.lspinstall",
	"sierda.plug-settings.cmp",
	"sierda.plug-settings.lsp",
	"sierda.plug-settings.telescope",
	"sierda.plug-settings.gitworktree",
	"sierda.plug-settings.tmux",
	"sierda.plug-settings.treesitter"
}

function M:config()
  for _,set in ipairs(settings) do
    require(set)
  end
end

return M:config()
