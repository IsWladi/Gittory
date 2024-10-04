-- I´m just trying to use the workspace_analizer tool to get a list of workspaces and open them with telescope
-- Load this file with :luafile % and then you can use the commands :OpenWorkspaces and :FetchWorkspaces
-- I think workspace_analizer is a bit slow, maybe I can improve it

local M = {}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values


function M.fetch_workspaces(path)
  local cmd = { '/home/iswladi/workspace/Gittory/workspace_analizer/target/debug/workspace_analizer', '-p', path, '-d', '5' }
  local command = table.concat(cmd, ' ')
  local result = vim.fn.system(command)
  local workspace_results = {}

  if vim.v.shell_error == 0 then
    local data = vim.fn.json_decode(result)

    for _, item in ipairs(data) do
      table.insert(workspace_results, item.name .. " ---> " .. item.path)
    end
    return workspace_results
  else
    -- Manejo de errores en caso de que el comando falle
    vim.api.nvim_err_writeln("Error executing workspace_analizer: " .. result)
    return nil
  end
end

function M.open_workspaces(workspace_results)
  if #workspace_results == 0 then
    vim.api.nvim_err_writeln("No workspaces found")
    return
  end

  pickers.new({}, {
    prompt_title = "Workspaces",
    finder = finders.new_table {
      results = workspace_results
    },
    sorter = conf.generic_sorter({}),
  }):find()
end

return M

