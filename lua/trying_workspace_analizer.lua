-- I´m just trying to use the workspace_analizer tool to get a list of workspaces and open them with telescope
-- Load this file with :luafile % and then you can use the commands :OpenWorkspaces and :FetchWorkspaces
-- I think workspace_analizer is a bit slow, maybe I can improve it

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

local workspace_results = {}

local function fetch_workspaces()
  vim.system({ '/home/iswladi/workspace/Gittory/workspace_analizer/target/debug/workspace_analizer', '-p', '/home/iswladi/workspace/', '-d', '5' }, { text = true }, vim.schedule_wrap(function(obj)
    if obj.code == 0 then
      local result = obj.stdout

      local data = vim.fn.json_decode(result)

      workspace_results = {}
      for _, item in ipairs(data) do
        table.insert(workspace_results, item.name .. " ---> " .. item.path)
      end
      print("workspace data updated")
    else
      -- Manejo de errores en caso de que el comando falle
      vim.schedule(function()
        vim.api.nvim_err_writeln("Error executing workspace_analizer: " .. obj.stderr)
      end)
    end
  end))
end

vim.api.nvim_create_user_command('OpenWorkspaces', function()
  if #workspace_results == 0 then
    vim.api.nvim_err_writeln("No data available. Please wait a moment or run :FetchWorkspaces.")
    return
  end

  pickers.new({}, {
    prompt_title = "Workspaces",
    finder = finders.new_table {
      results = workspace_results
    },
    sorter = conf.generic_sorter({}),
  }):find()
end, {})

vim.api.nvim_create_user_command('FetchWorkspaces', function()
  fetch_workspaces()
  print("Updating workspace data...")
end, {})
