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

	"plug-settings.material",
	"plug-settings.gitsings",
	"plug-settings.lspinstall",
	"plug-settings.cmp",
	"plug-settings.lsp",
	"plug-settings.telescope",
	"plug-settings.gitworktree",
	"plug-settings.tmux",
	"plug-settings.treesitter"
}

function M:config()
  for _,set in ipairs(settings) do
    require(set)
  end
end

return M:config()
