local notify = require('notify')
local M = {}

-- Function to check if the current directory is a Git repository
function M.isGitRepository()
  local windows = string.lower(vim.loop.os_uname().sysname)
  local isWindows = string.match(windows, "windows")
  local isGit = nil

  if not isWindows then
    isGit = os.execute('git status > /dev/null 2>&1') -- 0 if it is a Git repository, 1 if it is not, the return message is saved in /dev/null (it is deleted)
  else
    isGit = os.execute('git status > NUL 2>&1') -- 0 if it is a Git repository, 1 if it is not, the return message is saved in NUL (it is deleted)
  end

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

  if vim.fn.expand('%:p') ~= '' then
    vim.cmd("cd %:h")
  end

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

-- No git functions

function M.telescope_home()
  local builtin = require('telescope.builtin').find_files
  local actual_path =  vim.fn.getcwd()
  vim.cmd("cd $HOME")
  builtin({
    attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            vim.cmd("cd " .. actual_path)
        end)
        return true
    end  })
  notify("In you'r home", 'info', { title = 'Gittory Home', render = "compact" })
end

return M
