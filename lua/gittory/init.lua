local M = {}

-- for save the path where the user opened Neovim
M.backUpPath = nil

local gitSetup = require("gittory.git_setup") -- charge git functions

function M.setup(options)
	options = options or {}
	local atStartUp = true
	if options.atStartUp == false then
		atStartUp = false
	end
	local notifySettings = {
		enabled = true,
		-- you can change the order of the plugins
		availableNotifyPlugins = { "notify", "print" },
	}

  if options.notifySettings ~= nil then
    if options.notifySettings.availableNotifyPlugins ~= nil then
      notifySettings.availableNotifyPlugins = options.notifySettings.availableNotifyPlugins
    end

    if options.notifySettings.enabled == false then
      notifySettings.enabled = false
    end
  end


	-- set notifications function, if not installed, then use the default print function with printMessage function
	M.notifyPlugin = {}
	-- set to M.notifyPlugin the first available plugin with a for loop with pcall
	if notifySettings.availableNotifyPlugins == "" then
		M.notifyPlugin = { pluginName = "print" }
	else
		for _, notifyPluginName in ipairs(notifySettings.availableNotifyPlugins) do
			if notifyPluginName == "print" then
				M.notifyPlugin = { pluginName = notifyPluginName }
				break
			end
			local ok, plugin = pcall(require, notifyPluginName)
			if ok then
				M.notifyPlugin = { plugin = plugin, pluginName = notifyPluginName }
				break
			end
		end
	end
	if M.notifyPlugin.pluginName == nil then -- if all the available plugins are not installed, then use the default print function
		M.notifyPlugin.pluginName = "print"
	end

	-- this part is for protect the variable M.backUpPath to be overwritten and don´t lose the backup path
	local path = vim.loop.cwd()
	M.backUpPath = path -- for use in the nvim_create_user_command for desactivate gittory

	vim.api.nvim_create_user_command("GittoryInit", function()
		gitSetup.set_git_root({
			notify = notifySettings.enabled,
			notifyPlugin = M.notifyPlugin,
		})
	end, { desc = "Gittory is for set the cwd of your git proyect" })

	vim.api.nvim_create_user_command("GittoryDesactivate", function()
		gitSetup.set_git_root({
			notify = notifySettings.enabled,
			notifyPlugin = M.notifyPlugin,
			backUpPath = M.backUpPath,
		})
	end, { desc = "Gittory is for set the cwd of your git proyect" })

	if atStartUp == true then
		gitSetup.set_git_root({
			notify = notifySettings.enabled,
			notifyPlugin = M.notifyPlugin,
		}) -- Set the root directory of the Git repository for being used at startup of Neovim
	end
end

return M
