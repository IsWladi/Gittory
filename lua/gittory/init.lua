local M = {}

local backUpPath = nil -- to save the path where the user opened Neovim

local gitSetup = require("gittory.git_setup") -- charge git functions
local utils = require("gittory.utils") -- charge utils functions

function M.setup(options)
  local mergedUserSettings = require("gittory.defaults").mergeUserConfig(options)

	local atStartUp = mergedUserSettings.atStartUp
	local notifySettings = mergedUserSettings.notifySettings

	-- set notifications function, if not installed, then use the print(message) lua function
	local notifyPlugin = require("gittory.utils").getNotifyPlugin(notifySettings.availableNotifyPlugins)

  vim.api.nvim_create_user_command(
  'Gittory',
  function(opts)
    if opts.args == '' or opts.args == 'init' then
      if not backUpPath and not GitRootPath then
        backUpPath = vim.loop.cwd()
        gitSetup.set_git_root({
          notify = notifySettings.enabled,
          notifyPlugin = notifyPlugin,
          title = notifySettings.messagesConfig.title,
          prompt = notifySettings.messagesConfig.commandsMessages.init.cmdHead,
          notGitRepositoryMessage = notifySettings.messagesConfig.commandsMessages.init.errors.notGitRepository,
        })
      elseif notifySettings.enabled then
        utils.printInfoMessage({
          title = mergedUserSettings.notifySettings.messagesConfig.title,
          message = mergedUserSettings.notifySettings.messagesConfig.commandsMessages.init.errors.alreadyInitialized,
          notifyPlugin = notifyPlugin
        })
      end
    elseif opts.args == 'finish' then
      if backUpPath and GitRootPath then
        -- change the cwd to the path where the user opened Neovim
        vim.api.nvim_set_current_dir(backUpPath)
        -- reset to nil the backUpPath variable and the GitRootPath variable
        backUpPath = nil
        GitRootPath = nil
        --print message
        if notifySettings.enabled then
          utils.printMessage({
            cwd = vim.loop.cwd(),
            title = mergedUserSettings.notifySettings.messagesConfig.title,
            prompt = mergedUserSettings.notifySettings.messagesConfig.commandsMessages.finish.cmdHead,
            notifyPlugin = notifyPlugin,
          })
        end
      elseif notifySettings.enabled then
        utils.printInfoMessage({
          title = mergedUserSettings.notifySettings.messagesConfig.title,
          message = mergedUserSettings.notifySettings.messagesConfig.commandsMessages.commonErrors.notInitializedYet,
          notifyPlugin = notifyPlugin
        })
      end
    elseif opts.args == 'toggle' then
      if backUpPath and GitRootPath then -- finish
        vim.cmd('Gittory finish')

      else -- init
        vim.cmd('Gittory init')
      end
    elseif opts.args == 'root' then
      -- change the cwd to the root of the git repository setted when Gittory init was executed
      -- so, if the user use "cd .." or "cd /" or "cd ~" and then use "Gittory root",
      -- the user will be in the root of the git repository setted when Gittory init was executed (it won´t be lost)
      --if Gittory has´nt been activated, ¿what to do? -> solution?: show a message that says that Gittory has´nt been activated
      if backUpPath and GitRootPath then
        vim.api.nvim_set_current_dir(GitRootPath)

        --print message
        if notifySettings.enabled then
          utils.printMessage({
            cwd = vim.loop.cwd(),
            title = mergedUserSettings.notifySettings.messagesConfig.title,
            prompt = mergedUserSettings.notifySettings.messagesConfig.commandsMessages.root.cmdHead,
            notifyPlugin = notifyPlugin,
          })
        end
      elseif notifySettings.enabled then
        utils.printInfoMessage({
          title = mergedUserSettings.notifySettings.messagesConfig.title,
          message = mergedUserSettings.notifySettings.messagesConfig.commandsMessages.commonErrors.notInitializedYet,
          notifyPlugin = notifyPlugin
        })

      end

    elseif opts.args == 'backup' then
      -- change the cwd to the path where the user opened Neovim
      --if Gittory has´nt been activated, ¿what to do? -> solution?: show a message that says that Gittory has´nt been activated
      if backUpPath and GitRootPath then
        vim.api.nvim_set_current_dir(backUpPath)

        if notifySettings.enabled then
          utils.printMessage({
            cwd = vim.loop.cwd(),
            title = mergedUserSettings.notifySettings.messagesConfig.title,
            prompt = mergedUserSettings.notifySettings.messagesConfig.commandsMessages.backup.cmdHead,
            notifyPlugin = notifyPlugin,
          })
        end
      elseif notifySettings.enabled then
        utils.printInfoMessage({
          title = mergedUserSettings.notifySettings.messagesConfig.title,
          message = mergedUserSettings.notifySettings.messagesConfig.commandsMessages.commonErrors.notInitializedYet,
          notifyPlugin = notifyPlugin
        })
      end
    end
  end,
  {
    nargs = '*',
    -- update the description
    desc ="A custom NeoVim command for the Gittory plugin designed to enhance your workflow by managing the current working directory (cwd) with ease. Use 'init' for setup, 'desactivate' to undo, 'root' to navigate to the Git root, and 'backup' to revert to the initial path. For more information, see :help Gittory.",
    complete = function(ArgLead, CmdLine, CursorPos)
      local completions = {"init", "finish", "toggle", "root", "backup"}
      local matches = {}
      for _, completion in ipairs(completions) do
        if completion:find("^" .. ArgLead) then
          table.insert(matches, completion)
        end
      end
      return matches
    end,
  }
  )

	if atStartUp == true then -- if the user wants to set the root of the git repository at the start up
    backUpPath = vim.loop.cwd()
		gitSetup.set_git_root({
			notify = notifySettings.enabled,
      notifyPlugin = notifyPlugin,
      title = notifySettings.messagesConfig.title,
      prompt = notifySettings.messagesConfig.commandsMessages.init.cmdHead,
      notGitRepositoryMessage = notifySettings.messagesConfig.commandsMessages.init.error,
		})
	end
end

return M
