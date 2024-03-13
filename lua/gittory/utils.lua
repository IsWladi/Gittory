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

function M.printMessage(opts)
  local path = opts.cwd
  local projectName = path:match("[^/\\]+$") -- get the last folder
  if projectName == "." then -- for fix the bug when the root of the git repository is the same as the cwd
    projectName = vim.loop.cwd():match("[^/\\]+$") -- get the name of the folder´s project and avoid "/./" in the message
  end
  -- TODO: get the previous folder to add context to the path
  local message = opts.title .. " " .. opts.prompt .. "/" .. projectName .. "/"

  opts.notifyPlugin.plugin.notify(message)
end


function M.printInfoMessage(opts)
  local message = opts.title .. ": " .. opts.message
  opts.notifyPlugin.plugin.notify(message)
end

return M
