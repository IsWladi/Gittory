-- ENSURE THAT YOU OPPENED NEOVIM AT THE ROOT OF THE GITTORY REPOSITORY ~/path/to/Gittory/
-- SO THAT THE TESTS CAN BE EXECUTED CORRECTLY

describe("Git functions ->", function()
	GitSetup = require("gittory.git_setup")

  local rootRepoDir

  before_each(function()
    rootRepoDir = vim.fn.getcwd() -- Assuming that the cwd is ~/path/to/Gittory/
  end)

  after_each(function()
    -- restore previous cwd
    vim.api.nvim_set_current_dir(rootRepoDir)
  end)

	describe("M.isGitRepository()", function()
		it("Detecting a Valid Git Repository Presence", function()
			assert.equals(true, GitSetup.isGitRepository())
		end)

		it("Identifying Non-Git Directory Correctly", function()
			vim.api.nvim_set_current_dir("~/") -- set home as the cwd because it's not usually a git repository

			assert.equals(false, GitSetup.isGitRepository())

		end)
	end)

	describe("M.get_git_root()", function()
		it("Accurate Retrieval of the Git Root Path", function()
			-- Assuming that the cwd is ~/path/to/Gittory/
			local expectedGitRootPath = vim.fn.getcwd()
			local response = GitSetup.get_git_root()
			assert.equals(response, expectedGitRootPath)
		end)
	end)

	describe("M.set_git_root()", function()
		it("Setting the Current Working Directory to the Git Root Path", function()
      vim.api.nvim_set_current_dir("../Gittory/") -- change the cwd to a subdirectory of the repository
      GitSetup.set_git_root({
        notify = false,
        notifyPlugin = {},
      })
      local afterGittorySetRoot = vim.fn.getcwd()
      assert.equals(afterGittorySetRoot, rootRepoDir)
		end)
	end)
end)
