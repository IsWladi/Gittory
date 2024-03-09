-- ENSURE THAT YOU OPPENED NEOVIM AT THE ROOT OF THE GITTORY REPOSITORY ~/path/to/Gittory/
-- SO THAT THE TESTS CAN BE EXECUTED CORRECTLY

describe("git_setup", function()
	GitSetup = require("gittory.git_setup")

	describe("M.isGitRepository()", function()
		it("validates if it is a git repository", function()
			assert.equals(true, GitSetup.isGitRepository())
		end)

		it("validates if it is not a git repository", function()
			local actualDir = vim.fn.getcwd() -- don't lose the current path
			vim.api.nvim_set_current_dir("~/") -- set home as the cwd because it's not usually a git repository

			assert.equals(false, GitSetup.isGitRepository())

			vim.api.nvim_set_current_dir(actualDir) -- restore previous cwd
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
end)

-- describe("blablabla", function ()
--
-- end)
