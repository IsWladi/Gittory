# Gittory

## Project status
This project is in an early stage of development. Although it is already fully functional, it may not work as desired since it has only been tested by me and with my Neovim configuration and workflow. I have not been able to test it on Unix operating systems, only on Windows, although the code is designed to work on all systems. Any feedback on the plugin’s performance is appreciated.

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


## Dependencies
Gittory don´t depends on other plugins, but it´s better with:
- notify.nvim

## Installation
- This plugin doesn't have default keymaps.
- You can install Gittory using your preferred package manager. Here's an example using `lazy.nvim`:

```lua
return{
  {"Wladimir3984/gittory",

    branch = "main", -- for tested version of the plugin

    dependencies = {
        {"rcarriga/nvim-notify"},
    },
    init = function()
      local gittory = require('gittory')
      gittory.setup{
          notify = "yes",
          atStartUp = "yes"
        }
    end,
  }

}
```

## Examples of Keymaps with lazy.nvim
there are two commands, :GittoryInit and :GittoryDesactivate.  
:GittoryInit = if `atStartUp = "not"` then init Gittory and set the cwd at the git root of the project.  
:GittoryDesactivate = desactivate Gittory and set the initial path before set de git root workdirectory

## Contributing
If you would like to contribute to the development of Gittory, you can do so by submitting a pull request or opening an issue on the project’s GitHub repository.
