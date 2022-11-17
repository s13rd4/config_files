local plugin_loader = {} 

function plugin_loader:init()

  local execute = vim.api.nvim_command
  local fn = vim.fn

  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

  if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
	execute 'packadd packer.nvim'
  end

  local packer_ok, packer = pcall(require, "packer")
  if not packer_ok then
    return
  end

  local util = require "packer.util"

  packer.init {
    package_root = util.join_paths(fn.stdpath('data')..'/site/pack'),
    git = { clone_timeout = 300 },
    display = {
      open_fn = function()
        return util.float { border = "rounded" }
      end,
    },
  }

  self.packer = packer
  return self
end

function plugin_loader:load(plugins)
  return self.packer.startup(function(use)
      for _, plugin in ipairs(plugins) do
        use(plugin)
      end
    end)
end

return {
  init = function()
    return plugin_loader:init()
  end,
}
