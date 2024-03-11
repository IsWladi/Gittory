local M = {}

-- for save the path where the user opened Neovim
local backUpPath = nil

local gitSetup = require("gittory.git_setup") -- charge git functions

function M.setup(options)
  local mergedUserSettings = require("gittory.defaults").mergeUserConfig(options)

	local atStartUp = mergedUserSettings.atStartUp
	local notifySettings = mergedUserSettings.notifySettings

	-- set notifications function, if not installed, then use the print(message) lua function
	local notifyPlugin = require("gittory.utils").getNotifyPlugin(notifySettings.availableNotifyPlugins)

	-- this part is for protect the variable backUpPath to be overwritten and don´t lose the backup path
	local path = vim.loop.cwd()
	backUpPath = path -- for use in the nvim_create_user_command for desactivate gittory

	vim.api.nvim_create_user_command("GittoryInit", function()
		gitSetup.set_git_root({
			notify = notifySettings.enabled,
			notifyPlugin = notifyPlugin,
		})
	end, { desc = "Gittory is for set the cwd of your git proyect" })

	vim.api.nvim_create_user_command("GittoryDesactivate", function()
		gitSetup.set_git_root({
			notify = notifySettings.enabled,
			notifyPlugin = notifyPlugin,
			backUpPath = backUpPath,
		})
	end, { desc = "Gittory is for set the cwd of your git proyect" })

	if atStartUp == true then
		gitSetup.set_git_root({
			notify = notifySettings.enabled,
			notifyPlugin = notifyPlugin,
		}) -- Set the root directory of the Git repository for being used at startup of Neovim
	end
end

return M
