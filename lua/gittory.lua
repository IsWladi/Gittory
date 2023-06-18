local M = {}
local ok, notify = pcall(require, 'notify')
if not ok then
  notify = vim.notify
end

M.settings = {}
M.settings.notify = "not"
M.settings.atStartUp = "not"

-- Function to check if the current directory is a Git repository
function M.isGitRepository()
  local windows = string.lower(vim.loop.os_uname().sysname)
  local isWindows = string.match(windows, "windows")
  local isGit = nil

  if not isWindows then
    isGit = os.execute('git status > /dev/null 2>&1') -- 0 if it is a Git repository, 1 if it is not, the return message is saved in /dev/null (it is deleted)
  else
    isGit = os.execute('git status > NUL 2>&1') -- For Unix systems, not tested right now
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

-- Function to set the root directory of the Git repository for being used at startup of Neovim
function M.set_git_root()
  local path = vim.loop.cwd()
  local home = vim.loop.os_homedir()
  local i = 0
  local is_git = M.isGitRepository()
  if is_git then
    while path ~= home do
      if vim.fn.isdirectory(path .. '/.git') == 1 then
        vim.api.nvim_set_current_dir(path) -- Change the current directory to the root of the Git repository
        if M.settings.notify == "yes" then
          notify(path, 'success', { title = 'Gittory init', render = "compact" })
        end
        return
      end
      path = vim.fn.fnamemodify(path, ':h')
      i = i + 1
    end

    if M.settings.notify == "yes" then
    notify('No .git found. The search is maximum up to /home/', 'error', { title = 'Gittory' })
    end
  elseif M.settings.notify == "yes" then
    notify('This is not a Git repository. The actual path is being used.', 'info', { title = 'Gittory', render = "compact" })
  end
end

function M.setup()
  vim.api.nvim_create_user_command("Gittory_set_git_cwd",
    function ()
      M.set_git_root()
    end
    ,{})
  if M.settings.atStartUp == "yes" then
    M.set_git_root() -- Set the root directory of the Git repository for being used at startup of Neovim
  end
end

return M

