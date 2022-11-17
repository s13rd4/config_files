M = {}

--[[local function scandir(directory)
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

local mappings = scandir("mappings")
]]

local mappings = {
	"sierda.mappings.global",
	"sierda.mappings.git",
}

function M:config()
  for _,map in ipairs(mappings) do
    require(map)
  end
end

return M:config()
