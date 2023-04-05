# Gittory

## Introduction
Gittory is a Neovim plugin that provides functions for working with Git repositories. It allows you to use Telescope to search the entire working directory of the Git repository, regardless of your relative position within the repository. If there is no Git repository, the Telescope operation will be canceled.

## Features
- `search_git_root(builtin, args)`: Searches the entire working directory of the Git repository with Telescope.
  - example: `search_git_root(require('telescope.builtin').grep_string, {use_regex = true})`

## Installation
You can install Gittory using your preferred package manager. Here's an example using `lazy.nvim`:

```lua
return{
  {"Wladimir3984/gittory",
    dependencies = {
        {"nvim-telescope/telescope.nvim"},
        {"rcarriga/nvim-notify"},
    },
    keys = {
      { "<leader>ff", function() require('gittory').search_git_root() end, desc = '[telescope gittory] find files' },

      { "<leader>fg", function() require('gittory').search_git_root(require('telescope.builtin').live_grep) end,
      desc = '[telescope gittory] live grep' },

      { "<CR>", function() require('gittory').search_git_root(require('telescope.builtin').grep_string,{use_regex = true}) end,
      mode = "x", desc = '[telescope gittory] string grep visual mode with regex' },
    },
  }
}
```

## Usage
To use Gittory’s search_git_root function, you can call it like this: require('gittory').search_git_root(). You can also pass in arguments to specify the Telescope builtin function and its arguments. For example: require('gittory').search_git_root(require('telescope.builtin').grep_string, {use_regex = true}).

## Dependencies
Gittory depends on the following plugins:

- notify.nvim
- telescope.nvim

## Contributing
If you would like to contribute to the development of Gittory, you can do so by submitting a pull request or opening an issue on the project’s GitHub repository.
