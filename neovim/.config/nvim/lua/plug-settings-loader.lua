M = {}

local settings = {
  "plug-settings.material",
  "plug-settings.gitsings",
  "plug-settings.lspinstall",
  "plug-settings.cmp",
  "plug-settings.telescope",
  "plug-settings.tmux",
}

function M:config()
  for _,set in ipairs(settings) do
    require(set)
  end
end

return M:config()
