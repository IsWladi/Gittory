-- ENSURE THAT YOU OPPENED NEOVIM AT THE ROOT OF THE GITTORY REPOSITORY ~/path/to/Gittory/
-- SO THAT THE TESTS CAN BE EXECUTED CORRECTLY

describe("git_setup.lua file ->", function()
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
		it("validates if it is a git repository", function()
			assert.equals(true, GitSetup.isGitRepository())
		end)

		it("validates if it is not a git repository", function()
			vim.api.nvim_set_current_dir("~/") -- set home as the cwd because it's not usually a git repository

			assert.equals(false, GitSetup.isGitRepository())

		end)
	end)

	describe("M.get_git_root()", function()
		it("Validates that the git root path is correct.", function()
			-- Assuming that the cwd is ~/path/to/Gittory/
			local expectedGitRootPath = vim.fn.getcwd()
			local response = GitSetup.get_git_root()
			assert.equals(response, expectedGitRootPath)
		end)
	end)

	describe("M.set_git_root()", function()
		it("Validates set_git_root.", function()
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
