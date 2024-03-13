-- This file contains the default settings for the plugin
local M = {}

M._defaultOptions = {
  atStartUp = true,
  notifySettings = {
    enabled = true,
    -- the user can change the order of the plugins
    availableNotifyPlugins = { "notify", "print" },
    messagesConfig = {
      title = "Gittory",
      commandsMessages = {
        commonErrors = {
          notActivatedYet = "The plugin has not been activated yet.",
        },
        init = {
          cmdHead = "activated: ",
          error = "This is not a Git repository. The actual path is being used.",
        },
        deactivate = {
          cmdHead = "deactivated: ",
        },
        reset = {
          cmdHead = "reseted: ",
        },
        root = {
          cmdHead = "root: ",
        },
        backup = {
          cmdHead = "backup: ",
        },
      },
    },
	}
}

function M.mergeUserConfig(userOptions)
  local mergedConfig = vim.tbl_deep_extend("keep", userOptions or {}, M._defaultOptions)

  -- manage nil values

  -- tables
  mergedConfig.notifySettings = mergedConfig.notifySettings or M._defaultOptions.notifySettings
  mergedConfig.notifySettings.availableNotifyPlugins = mergedConfig.notifySettings.availableNotifyPlugins or M._defaultOptions.notifySettings.availableNotifyPlugins
  -- mergedConfig.notifySettings.messagesConfig = mergedConfig.notifySettings.messagesConfig or M._defaultOptions.notifySettings.messagesConfig

  -- booleans
  if mergedConfig.atStartUp == nil then
    mergedConfig.atStartUp = M._defaultOptions.atStartUp
  end
  if mergedConfig.notifySettings.enabled == nil then
    mergedConfig.notifySettings.enabled = M._defaultOptions.notifySettings.enabled
  end

  return mergedConfig
end

return M
