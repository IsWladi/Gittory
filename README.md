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


## Features
- `search_git_root(builtin, args)`: Searches the entire working directory of the Git repository with Telescope's builtin functions.
- `telescope_home()`: Use `find_files` to search for files from your system’s HOME directory with Telescope. 


## Dependencies
Gittory depends on the following plugins:
- telescope.nvim
- notify.nvim


## Installation
- This plugin doesn't have default keymaps.
- You can install Gittory using your preferred package manager. Here's an example using `lazy.nvim`:

```lua
return{

  {"Wladimir3984/gittory",
    dependencies = {
        {"nvim-telescope/telescope.nvim"},
        {"rcarriga/nvim-notify"},
    },
  }

}
```

## Examples of Keymaps with lazy.nvim
These are some keymaps that I think are logical to use with Gittory. While it is possible that almost all of Telescope’s built-in functions can be used with Gittory, not all of them make sense to use, as it could result in undesired behavior.

```lua
return{

  {"Wladimir3984/gittory",
    dependencies = {
        {"nvim-telescope/telescope.nvim"},
        {"rcarriga/nvim-notify"},
    },
    keys = {
      { "<leader>ff", function() 
                        require('gittory').search_git_root() -- For default: find_files
                      end, 
      desc = '[telescope gittory] find files' },

      { "<leader>fg", function() 
                        local liveGrep = require('telescope.builtin').live_grep
                        require('gittory').search_git_root(liveGrep) 
                      end,
      desc = '[telescope gittory] live grep' },

      { "<CR>", function() 
                  local grepString = require('telescope.builtin').grep_string -- find a selected text in you'r entire Git repository using regex
                  local args = {use_regex = true}
                  require('gittory').search_git_root(grepString, args) 
                end,
      mode = "x", desc = '[telescope gittory] string grep visual mode with regex' },
      
      { "<leader><leader>h", function() require('gittory').telescope_home() end, -- Find from you'r home
       desc = '[telescope gittory] find from home with telescope' },
      
    },
  }    
    
}
```



## Contributing
If you would like to contribute to the development of Gittory, you can do so by submitting a pull request or opening an issue on the project’s GitHub repository.
