M = {}

settings = {
  "plug-settings.material"
}

function M:config()
  for _,set in ipairs(settings) do
    require(set)
  end
end

return M:config()
