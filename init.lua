local M = {}

M.gittory = require("gittory")

-- Llamar a la función set_git_root() al iniciar Neovim
M.gittory.set_git_root()
return M
