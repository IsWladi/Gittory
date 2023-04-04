# Gittory

Gittory is a Neovim plugin that provides functions for working with Git repositories. It allows you to use Telescope to search the entire working directory of the Git repository, regardless of your relative position within the repository. If there is no Git repository, the Telescope operation will be canceled.

## Features

- `search_git_root(builtin, args)`: Searches the entire working directory of the Git repository with Telescope.
  - example: `search_git_root(require('telescope.builtin').grep_string, {use_regex = true})`
  
## Dependencies

Gittory depends on the following plugins:
- notify.nvim
- telescope.nvim

## Usage

To use Gittory in your Neovim configuration:

```lua
--You must require it:
local gittory = require('gittory')

--Then you can call the functions provided by the plugin. For example, to use builtin.find_files in the actual working directory of the Git repository:
gittory.search_git_root()--If you don´t pass arguments the default is require('telescope.builtin').find_files, if you want to be explicit use: gittory.search_git_root(require('telescope.builtin').find_files)


You can set key mappings to call Telescope with Gittory’s functions:

gittory = require("gittory")
vim.keymap.set("n", "<leader>ff",
              function() gittory.search_git_root() end,
              { noremap = true, silent = true, desc = '[telescope gittory] find files' }
              )

vim.keymap.set("n", "<leader>fg",
              function() gittory.search_git_root(require('telescope.builtin').live_grep) end,
              { noremap = true, silent = true, desc = '[telescope gittory] live grep' }
              )

vim.keymap.set("x", "<CR>",
              function() gittory.search_git_root(require('telescope.builtin').grep_string, {use_regex = true}) end,
              { noremap = true, silent = true, desc = '[telescope gittory] string grep visual mode with regex' }
              )
```
