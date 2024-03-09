-- ENSURE THAT YOU OPPENED NEOVIM AT THE ROOT OF THE GITTORY REPOSITORY ~/path/to/Gittory/
-- SO THAT THE TESTS CAN BE EXECUTED CORRECTLY

describe("init.lua file -> ", function()

  GitInit = require("gittory.init")

  -- to save the root directory before changing it
  -- it can be used inside the tests
  local rootRepoDir

  before_each(function()
    rootRepoDir = vim.fn.getcwd() -- Assuming that the cwd is ~/path/to/Gittory/
  end)

  after_each(function()
    -- restore previous cwd
    vim.api.nvim_set_current_dir(rootRepoDir)
  end)

  it("Validates :GittoryDesactivate and :GittoryInit.", function()
    vim.api.nvim_set_current_dir("../Gittory/") -- change the cwd to a subdirectory of the repository
    local subDirPath = vim.fn.getcwd()
    GitInit.setup({
      atStartUp = true,
      notifySettings = {
        enabled = false,
      }
    })
    --execute the :GittoryDesactivate command
    vim.cmd("GittoryDesactivate")
    local afterGittoryDesactivate = vim.fn.getcwd()
    assert.equals(afterGittoryDesactivate, subDirPath)

    --execute the :GittoryInit command
    vim.cmd("GittoryInit")
    assert.equals(vim.fn.getcwd(), rootRepoDir)
  end)


  it("Validates atStartUp flag.", function()
    vim.api.nvim_set_current_dir("../Gittory/") -- change the cwd to a subdirectory of the repository
    local subDirPath = vim.fn.getcwd()
    GitInit.setup({
      atStartUp = false,
      notifySettings = {
        enabled = false,
      }
    })

    local afterGittorySetup = vim.fn.getcwd()
    assert.equals(afterGittorySetup, subDirPath)
  end)


  it("Validates if the default configuration works.", function()
    vim.api.nvim_set_current_dir("../Gittory/") -- change the cwd to a subdirectory of the repository
    local ok, ret = pcall(GitInit.setup, {}) -- setup with no options
    assert.equals(true, ok) -- call to setup should not raise an error
    assert.equals(rootRepoDir, vim.fn.getcwd()) -- the cwd should change to the root of the repository
  end)
end)
