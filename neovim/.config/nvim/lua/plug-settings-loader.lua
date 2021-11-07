M = {}

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

local settings = scandir("./plug-settings")

function M:config()
  for _,set in ipairs(settings) do
    require(set)
  end
end

return M:config()
