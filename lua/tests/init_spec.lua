-- ENSURE THAT YOU OPPENED NEOVIM AT THE ROOT OF THE GITTORY REPOSITORY ~/path/to/Gittory/
-- SO THAT THE TESTS CAN BE EXECUTED CORRECTLY

describe("Plugin setup -> ", function()

  GitInit = require("gittory.init")

  -- disable notifications for tests
  -- otherwise, the tests will fail
  require("gittory.defaults")._defaultOptions.notifySettings.enabled = false

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

  it("Ensuring :Gittory deactivate and :Gittory init Commands Function Properly.", function()
    vim.api.nvim_set_current_dir("../Gittory/") -- change the cwd to a subdirectory of the repository
    local subDirPath = vim.fn.getcwd()
    GitInit.setup()
    --execute the :Gittory deactivate command
    vim.cmd("Gittory deactivate")
    local afterGittoryDeactivate = vim.fn.getcwd()
    assert.equals(afterGittoryDeactivate, subDirPath)

    --execute the :Gittory init command
    vim.cmd("Gittory init")
    assert.equals(vim.fn.getcwd(), rootRepoDir)
  end)

  it("Ensuring :Gittory root and :Gittory backup Commands Function Properly.", function()
    vim.api.nvim_set_current_dir("../Gittory/")
    local subDirPath = vim.fn.getcwd()
    GitInit.setup()
    vim.api.nvim_set_current_dir("../Gittory/")
    vim.cmd("Gittory root")
    assert.equals(vim.fn.getcwd(), rootRepoDir) -- it should be the root of the repository

    vim.cmd("Gittory backup")
    assert.equals(vim.fn.getcwd(), subDirPath) -- it should be the same as the working directory where neovim was opened

  end)


  it("Checking the atStartUp Flag's Effectiveness.", function()
    vim.api.nvim_set_current_dir("../Gittory/") -- change the cwd to a subdirectory of the repository
    local subDirPath = vim.fn.getcwd()
    GitInit.setup({
      atStartUp = false,
    })
    local afterGittorySetup = vim.fn.getcwd()
    assert.equals(afterGittorySetup, subDirPath)
  end)


  it("Confirming Default Configuration Applies Successfully.", function()
    vim.api.nvim_set_current_dir("../Gittory/") -- change the cwd to a subdirectory of the repository
    local ok, ret = pcall(GitInit.setup, {}) -- setup with no options
    assert.equals(rootRepoDir, vim.fn.getcwd()) -- the cwd should change to the root of the repository
    assert.equals(true, ok) -- call to setup should not raise an error
  end)
end)
