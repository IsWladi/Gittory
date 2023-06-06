local M = {}

M.gittory = require("gittory")

-- Llamar a la función set_git_root() al iniciar Neovim
vim.cmd([[autocmd VimEnter * lua require('gittory').gittory.set_git_root()]])

return M
