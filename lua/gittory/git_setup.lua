local M = {}

utils = require("gittory.utils")

-- Function to check if the current directory is a Git repository
function M.isGitRepository()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0 -- return true if the current directory is a Git repository
end

-- Function to get the root directory of the Git repository
function M.get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end

-- Function to set the root directory of the Git repository
function M.set_git_root(settings)
  -- When the user calls GittoryDesactivate, the settings.backUpPath is set to the current working directory where the user opened Neovim.
  -- if it is different from false, then the user wants to desactivate gittory
  settings.backUpPath = settings.backUpPath or false
  settings.isInitialized = settings.isInitialized or false

  local is_git = M.isGitRepository()

  if is_git then
    if settings.backUpPath ~= false then -- the user want to desactivate gittory with the command GittoryDesactivate
      vim.api.nvim_set_current_dir(settings.backUpPath)
      settings.isInitialized = false
      if settings.notify == true then

        utils.printResponseMessage('Actual folder: /'..settings.backUpPath:match("[^/\\]+$")..'/', "normal", "succes", settings.notifyPlugin) -- notify the path where the user opened Neovim
      end
    else -- the user want to activate gittory with the command GittoryInit or at startup
      git_root_path = M.get_git_root()
      vim.api.nvim_set_current_dir(git_root_path) -- Change the current directory to the root of the Git repository

      if settings.notify == true then  -- notify the root of the actual git repository
        utils.printResponseMessage("Folder´s project", "show path", "success", settings.notifyPlugin) -- notify the root of the actual git repository
      end
    end

  elseif settings.notify == true then
    utils.printResponseMessage("This is not a Git repository. The actual path is being used.", "normal", "info", settings.notifyPlugin)
  end
end

return M
