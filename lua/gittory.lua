notify = require('notify')
local M = {}

-- Función para buscar el directorio raíz del repositorio de Git
function M.find_git_root()
  local path = vim.loop.cwd()
  local i = 0
  while path:match('.:\\') and i < 10 do
    if vim.fn.isdirectory(path .. '/.git') == 1 then
      return path
    end
    path = vim.fn.fnamemodify(path, ':h')
    i = i + 1
  end
end

-- Función para buscar en todo el directorio de trabajo del repositorio de Git con Telescope
function M.search_git_root()
  local is_git = M.isGitRepository()
  if is_git then
    local git_root = M.find_git_root()
    if git_root then
      require('telescope.builtin').find_files({ cwd = git_root })
      notify('Directorio de trabajo git: ' .. git_root, 'succes', { title = 'Gittory' })
    else
      notify('El repositorio tiene 10 o más de profundidad\nEl plugin no lo soporta por ahora.', 'info', { title = 'Gittory' })
    end
  else
    notify('No es un repositorio de Git', 'error', { title = 'Gittory' })
  end
end

function M.isGitRepository()
  local isGit = os.execute('git status > NUL 2>&1') -- 0 si es un repositorio de Git, 1 si no lo es, el msg de retorno se guarda en NUL(se elimina)
  if type(isGit) == 'number' then --si es lua 5.2 o superior el tipo de retorno es number
    isGit = (isGit == 0)
  end
  if isGit then
    return true
  else
    return false
  end
end



return M
