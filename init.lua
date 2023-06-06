local M = {}

M.gittory = require("gittory")

local function setup_git_root()
  -- Llamar a la función set_git_root() aquí
  M.gittory.set_git_root()
end

-- Configurar el autocmd para ejecutar setup_git_root() en el evento VimEnter
vim.cmd([[
  augroup GittoryAutocmds
    autocmd!
    autocmd VimEnter * lua setup_git_root()
  augroup END
]])

return M
