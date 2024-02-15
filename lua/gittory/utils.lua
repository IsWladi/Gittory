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

-- Function to print various purposes messages
function M.printResponseMessage(response, options, type)
  if options == "show path" then
    local shortPath = git_root_path:match("[^/\\]+$") -- git_root_path is a global variable from the git_setup.lua file
    if shortPath == "." then -- for fix the bug when the root of the git repository is the same as the cwd
      shortPath = vim.loop.cwd():match("[^/\\]+$") -- get the name of the folder´s project and avoid "/./" in the message
    end
    response = response .. ': /'..shortPath..'/'
  end
  -- print the message
  vim.defer_fn(function()
    M.printMessage(response, type, { title = 'Gittory', render = "compact" })
  end, 1000) --  (1 seconds)
end

return M
