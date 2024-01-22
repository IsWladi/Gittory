local M = {}
local ok, notify = pcall(require, 'notify')
notify = ok and notify or false
M.backUpPath = nil

-- Function to check if the current directory is a Git repository
function M.isGitRepository()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0 -- return true if the current directory is a Git repository
end

function M.get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end

-- Function to print messages with or without the rcarriga/nvim-notify plugin.
function M.printMessage(isNotifyInstalled, message, type, options)
  if isNotifyInstalled then
    notify(message, type, options)
  else
    print(message)
  end
end

-- Function to print various purposes messages
function M.printResponseMessage(response, options, type)
  if options == "show path" then
    local shortPath = M.git_root_path:match("[^/\\]+$")
    if shortPath == "." then -- for fix the bug when the root of the git repository is the same as the cwd
      shortPath = vim.loop.cwd():match("[^/\\]+$") -- get the name of the folder´s project and avoid "/./" in the message
    end
    response = response .. ': /'..shortPath..'/'
  end
  -- print the message
  vim.defer_fn(function()
    M.printMessage(ok, response, type, { title = 'Gittory', render = "compact" })
  end, 1000) --  (1 seconds)
end

-- Function to set the root directory of the Git repository
function M.set_git_root(settings)
  -- When the user calls GittoryDesactivate, the settings.backUpPath is set to the current working directory where the user opened Neovim.
  -- if it is different from "not", then the user wants to desactivate gittory
  settings.backUpPath = settings.backUpPath or "not"

  -- this part is for protect the variable M.backUpPath to be overwritten and don´t lose the backup path
  if M.isInitialized ~= true then
    local path = vim.loop.cwd()
    M.backUpPath = path -- for use in the nvim_create_user_command for desactivate gittory
    M.isInitialized = true
  end
  local is_git = M.isGitRepository()

  if is_git then
    if settings.backUpPath ~= "not" then -- the user want to desactivate gittory with the command GittoryDesactivate
      vim.api.nvim_set_current_dir(settings.backUpPath)
      M.isInitialized = false
      if settings.notify == "yes" then
        M.printResponseMessage("Actual Folder", "show path", "succes") -- notify the path where the user opened Neovim
      end
    else -- the user want to activate gittory with the command GittoryInit or at startup
      M.git_root_path = M.get_git_root()
      vim.api.nvim_set_current_dir(M.git_root_path) -- Change the current directory to the root of the Git repository

      if settings.notify == "yes" then  -- notify the root of the actual git repository
        M.printResponseMessage("Folder´s project", "show path", "success") -- notify the root of the actual git repository
      end
    end

  elseif settings.notify == "yes" then
    M.printResponseMessage("This is not a Git repository. The actual path is being used.", "normal", "info")
  end
end

function M.setup(options)
  options = options or {}
  options.atStartUp = options.atStartUp or "not"
  options.notify = options.notify or "not"
  M.isInitialized = false -- for protect the variable M.backUpPath to be overwritten
  vim.api.nvim_create_user_command("GittoryInit",
    function ()
        M.set_git_root( {notify = options.notify} )
    end
    ,{desc="Gittory is for set the cwd of your git proyect"})

  vim.api.nvim_create_user_command("GittoryDesactivate",
    function ()
        M.set_git_root( {notify = options.notify, backUpPath = M.backUpPath} )
    end
    ,{desc="Gittory is for set the cwd of your git proyect"})

  if options.atStartUp == "yes" then
    M.set_git_root( {notify = options.notify} ) -- Set the root directory of the Git repository for being used at startup of Neovim
  end

end

return M
