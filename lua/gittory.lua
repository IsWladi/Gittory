local notify = require('notify')
local M = {}

-- Function to check if the current directory is a Git repository
function M.isGitRepository()

  local null_device = (vim.loop.os_uname().sysname == 'Windows') and 'NUL' or '/dev/null'
  local isGit = os.execute('git status > ' .. null_device .. ' 2>&1')

  if type(isGit) == 'number' then -- if it is lua 5.2 or higher the return type is number
    isGit = (isGit == 0)
  end
  if isGit then
    return true
  else
    return false
  end
end

-- Function to find the root directory of the Git repository
function M.find_git_root()
  local path = vim.loop.cwd()
  local home = vim.loop.os_homedir()
  local i = 0
  while path ~= home do
    if vim.fn.isdirectory(path .. '/.git') == 1 then
      return path
    end
    path = vim.fn.fnamemodify(path, ':h')
    i = i + 1
  end
  return false
end

-- Function to search the entire working directory of the Git repository with Telescope
function M.search_git_root(builtin, args)
  builtin = builtin or require('telescope.builtin').find_files
  args = args or {}

  local buffer_dir = vim.fn.expand('%:p:h')
  vim.api.nvim_set_current_dir(buffer_dir)

  local is_git = M.isGitRepository()
  if is_git then
    local git_root = M.find_git_root()
    if git_root then
      notify(git_root, 'succes', { title = 'Gittory', render = "compact" })
      args.cwd = git_root
      builtin(args)
    else
      notify('No .git found. The search is maximum up to /home/', 'error', { title = 'Gittory' })
    end
  else
    notify('This is not a Git repository. The actual path is being used.', 'info', { title = 'Gittory', render = "compact" })
    builtin(args)
  end
end

return M
