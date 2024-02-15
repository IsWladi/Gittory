local M = {}

gitSetup = require("gittory.git_setup")

-- for save the path where the user opened Neovim
M.backUpPath = nil

function M.setup(options)
  options = options or {}
  options.atStartUp = options.atStartUp or "not"
  options.notify = options.notify or "not"
  M.isInitialized = false -- for protect the variable M.backUpPath to be overwritten


  -- this part is for protect the variable M.backUpPath to be overwritten and don´t lose the backup path
  local path = vim.loop.cwd()
  M.backUpPath = path -- for use in the nvim_create_user_command for desactivate gittory

  vim.api.nvim_create_user_command("GittoryInit",
    function ()
        gitSetup.set_git_root( {notify = options.notify, isInitialized = M.isInitialized} )
        M.isInitialized = true
    end
    ,{desc="Gittory is for set the cwd of your git proyect"})

  vim.api.nvim_create_user_command("GittoryDesactivate",
    function ()
        gitSetup.set_git_root( {notify = options.notify, backUpPath = M.backUpPath, isInitialized = M.isInitialized} )
        M.isInitialized = false
    end
    ,{desc="Gittory is for set the cwd of your git proyect"})

  if options.atStartUp == "yes" then
    gitSetup.set_git_root( {notify = options.notify, isInitialized = M.isInitialized} ) -- Set the root directory of the Git repository for being used at startup of Neovim
    M.isInitialized = true
  end

end

return M
