# Gittory

## Introduction
Gittory is a Neovim plugin that provides functions for working with Git repositories. It allows you to use Telescope to search the entire working directory of the Git repository, regardless of your relative position within the repository.

### The problem
Imagine you have a project structured like this:
```
myProject
├── .git/
├── imgs/
│   ├── image1.png
│   ├── image2.jpg
│   └── image3.gif
├── js/
│   ├── chargeSomething.js
│   ├── other.js
│   └── andother.js
├── css/
│   ├── style.css
│   └── responsive.css
└── index.html
```
Suppose you navigate to the `js/` directory within the `myProject/` directory using the terminal command `cd ./myProject/js/` and open Neovim in this location. When you use Telescope, you’ll notice that you can only see the contents of the `js/` directory:
```
js/
├── chargeSomething.js
├── other.js
└── andother.js
```
that's a problem for me because I want to see all files on my proyect when I'am using git and don't think where I open nvim in the project. Gittory solves this by allowing you to use Telescope to search the entire working directory of the Git repository, regardless of your relative position within the repository.

### The solution
Before searching for the location of the `.git` directory, Gittory first checks if the current project is a Git project by running a `git status` command. If the current project is not a Git project, Gittory will still use Telescope but in the current buffer location. If the current project is a Git project, Gittory will search recursively through parent directories until it finds the `.git` folder and then call Telescope from this location. Whenever you call Telescope with Gittory, you'll be able to search your entire Git repository.


## Features
- `search_git_root(builtin, args)`: Searches the entire working directory of the Git repository with Telescope's builtin functions.


## Dependencies
Gittory depends on the following plugins:
- notify.nvim
- telescope.nvim


## Installation
- This plugin does'nt have default keymaps.
- You can install Gittory using your preferred package manager. Here's an example using `lazy.nvim`:

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
The plugin is very simple, in this lines of code you'll understand the usage:

![image](https://user-images.githubusercontent.com/83993271/229987331-9e0e1118-7263-4c9d-9c31-d0a7b3273cd8.png)

- To use Gittory’s `search_git_root()` function, you can call it like this: `require('gittory').search_git_root()`. 
- You can also pass in arguments to specify the Telescope builtin function and its arguments. 
  - For example: `require('gittory').search_git_root(require('telescope.builtin').grep_string, {use_regex = true})`.


## Contributing
If you would like to contribute to the development of Gittory, you can do so by submitting a pull request or opening an issue on the project’s GitHub repository.
