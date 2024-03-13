local M = {}

local utils = require("gittory.utils")

-- Function to check if the current directory is a Git repository
function M.isGitRepository()
	vim.fn.system("git rev-parse --is-inside-work-tree")
	return vim.v.shell_error == 0 -- return true if the current directory is a Git repository
end

-- Function to get the root directory of the Git repository
function M.get_git_root()
	local handle = io.popen("git rev-parse --show-toplevel")
	local result = handle:read("*a")
	handle:close()
	-- make result a valid path string
	result = string.gsub(result, "\n", "")
	return result
end

-- Function to set the root directory of the Git repository
function M.set_git_root(settings)
	local is_git = M.isGitRepository()
	if is_git then
    GitRootPath = M.get_git_root()
    vim.api.nvim_set_current_dir(GitRootPath) -- Change the current directory to the root of the Git repository
    if settings.notify == true then
      utils.printMessage({
        title = settings.title,
        prompt = settings.prompt,
        cwd = GitRootPath,
        notifyPlugin = settings.notifyPlugin,
      })
    end
  -- if is not a git repository
	elseif settings.notify == true then
    settings.notifyPlugin.plugin.notify(settings.title ..": " .. settings.notGitRepositoryMessage)
	end
end

return M
