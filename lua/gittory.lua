local M = {}
local ok, notify = pcall(require, 'notify')
if not ok then
  notify = vim.notify
end

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
function M.set_git_root(set_notify)
  local path = vim.loop.cwd()
  local home = vim.loop.os_homedir()
  local i = 0
  local is_git = M.isGitRepository()
  if is_git then
    while path ~= home do
      if vim.fn.isdirectory(path .. '/.git') == 1 then
        vim.api.nvim_set_current_dir(path) -- Change the current directory to the root of the Git repository
        if set_notify == "yes" then
          vim.defer_fn(function()
            notify(path, 'success', { title = 'Gittory init', render = "compact" })
          end, 1500) --  (1.5 segundos)
      end
        return
      end
      path = vim.fn.fnamemodify(path, ':h')
      i = i + 1
    end

    if set_notify == "yes" then
        vim.defer_fn(function()
          notify('No .git found. The search is maximum up to /home/', 'error', { title = 'Gittory' })
        end, 1500) --  (1.5 segundos)
    end
  elseif set_notify == "yes" then
    vim.defer_fn(function()
      notify('This is not a Git repository. The actual path is being used.', 'info', { title = 'Gittory', render = "compact" })
    end, 1500) --  (1.5 segundos)
  end
end

function M.setup(options)
  options = options or {notify="not", atStartUp="not"}
  vim.api.nvim_create_user_command("Gittory",
    function ()
      M.set_git_root(options.notify)
    end
    ,{desc="Gittory is for set the cwd of your git proyect"})

  if M.settings.atStartUp == "yes" then
    M.set_git_root(options.notify) -- Set the root directory of the Git repository for being used at startup of Neovim
  end

end

return M

