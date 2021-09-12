M = {}

local settings = {
  "plug-settings.material",
  "plug-settings.lspinstall",
  "plug-settings.cmp"
}

function M:config()
  for _,set in ipairs(settings) do
    require(set)
  end
end

return M:config()
