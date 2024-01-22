local M = {}

-- set notifications function, if not installed, then use the default print function with printMessage function
local ok, notify = pcall(require, 'notify')
notify = ok and notify or false

-- Function to print messages with or without the rcarriga/nvim-notify plugin.
function M.printMessage(message, type, options)
  if ok then
    notify(message, type, options)
  else
    print(message)
  end
end

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

return M
