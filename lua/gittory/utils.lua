local M = {}

-- return a table with the notification plugin name and the plugin itself
function M.getNotifyPlugin(availableNotifyPlugins)
  local notifyPlugin = {}
	if availableNotifyPlugins == "" then
		notifyPlugin = { pluginName = "print" }
	else
		for _, notifyPluginName in ipairs(availableNotifyPlugins) do
			if notifyPluginName == "print" then
				notifyPlugin = { pluginName = notifyPluginName }
				break
			end
			local ok, plugin = pcall(require, notifyPluginName)
			if ok then
				notifyPlugin = { plugin = plugin, pluginName = notifyPluginName }
				break
			end
		end
	end
	if notifyPlugin.pluginName == nil then -- if all the available plugins are not installed, then use the default print function
		notifyPlugin.pluginName = "print"
	end
  return notifyPlugin
end

-- Function to print various purposes messages
function M.printResponseMessage(response, options, type, notifyPlugin)
	if options == "show path" then
		local shortPath = GitRootPath:match("[^/\\]+$") -- GitRootPath is a global variable from the git_setup.lua file
		if shortPath == "." then -- for fix the bug when the root of the git repository is the same as the cwd
			shortPath = vim.loop.cwd():match("[^/\\]+$") -- get the name of the folder´s project and avoid "/./" in the message
		end
		response = response .. ": /" .. shortPath .. "/"
	end
	-- print the message
	vim.defer_fn(function()
		if notifyPlugin.pluginName == "notify" then
			notifyPlugin.plugin.notify(response, type, { title = "Gittory", render = "compact" })
		elseif notifyPlugin.pluginName == "print" then
			print(response)
		else -- for use any other notification plugin
			notifyPlugin.plugin.notify(response)
		end
	end, 1000) --  (1 seconds)
end

return M
