-- ENSURE THAT YOU OPPENED NEOVIM AT THE ROOT OF THE GITTORY REPOSITORY ~/path/to/Gittory/
-- SO THAT THE TESTS CAN BE EXECUTED CORRECTLY

describe("Plugin options -> ", function()

  local defaults = require("gittory.defaults")

  it("Verify Behavior with Empty Configuration", function()
    local defaultOptions = defaults._defaultOptions

    local mergedUserConfigEmpty = defaults.mergeUserConfig({})
    local mergedUserConfigNil = defaults.mergeUserConfig(nil)
    assert.equals(vim.inspect(defaultOptions), vim.inspect(mergedUserConfigEmpty))
    assert.equals(vim.inspect(defaultOptions), vim.inspect(mergedUserConfigNil))

  end)


  it("Validate Updating a Single Top-Level Configuration Field", function()
    local defaultOptions = defaults._defaultOptions
    local userConfig = {
      atStartUp = false,
    }
    local mergedUserConfig = defaults.mergeUserConfig(userConfig)
    local expected = {
      atStartUp = false,
      notifySettings = defaultOptions.notifySettings
    }

    assert.equals(vim.inspect(expected), vim.inspect(mergedUserConfig))



  end)

  it("Check Correct Update of a Specific Nested Field in Configuration", function()
    local defaultOptions = defaults._defaultOptions
    local userConfig = {
      notifySettings = {
        enabled = false,
      }
    }

    local mergedUserConfig = defaults.mergeUserConfig(userConfig)
    local expected = {
      atStartUp = defaultOptions.atStartUp,
      notifySettings = {
      enabled = false,
      availableNotifyPlugins = defaultOptions.notifySettings.availableNotifyPlugins,
      messagesConfig = defaultOptions.notifySettings.messagesConfig

      }
    }

    assert.equals(vim.inspect(expected), vim.inspect(mergedUserConfig))
  end)


  it("Handling Nil Values Gracefully", function()
    local defaultOptions = defaults._defaultOptions
    local userConfig = {
      atStartUp = nil,
      notifySettings = {
        enabled = nil,
        availableNotifyPlugins = nil,
      }
    }

    local mergedUserConfig = defaults.mergeUserConfig(userConfig)

    assert.equals(vim.inspect(defaultOptions), vim.inspect(mergedUserConfig))
  end)
end)
