# Gittory

## Project status
This project is in an early stage of development. Although it is already fully functional, it may not work as desired since it has only been tested by me and with my Neovim configuration and workflow. Tested only on Windows and Ubuntu, although the code is designed to work on all systems. Any feedback on the plugin’s performance is appreciated.
Look at the Trello board of this project to see the development flow: https://trello.com/b/5Sgb20pL/gittory-development

## Introduction
Gittory is a Neovim plugin that makes using the Telescope plugin easier. In simple terms, it changes the working directory to the root folder of your current project by finding the '.git' folder. It also works well with the Harpoon plugin. Whenever you open Neovim within a project, any marks you've made with Harpoon will be available, no matter which subfolder you opened Neovim in. Additionally, if you deactivate the plugin using the ':GittoryDesactivate' command, Neovim's working directory will return to where you originally opened it.

### An example
Imagine you have a project structured like this, and you're in the `js/` folder:
```
myProject
├── .git/
├── imgs/
│   ├── image1.png
│   ├── image2.jpg
│   └── image3.gif
├── js/ <------------------------------ You opened Neovim from the terminal here
│   ├── chargeSomething.js
│   ├── other.js
│   └── andOther.js
├── css/
│   ├── style.css
│   └── responsive.css
└── index.html
```
When you open Telescope without using Gittory, you will only see the scope of the folder you opened:
```
js/
├── chargeSomething.js
├── other.js
└── andOther.js
```
that's a problem for me because I want to see all files on my proyect when I'am using git and don't think where I open nvim in the project. Gittory solves this by allowing you to use Telescope to search the entire working directory of the Git repository, regardless of your relative position within the repository.

### The solution
Before searching for the location of the `.git/` directory, Gittory first checks if the current project is a Git project by running the git status command. If the current project is not a Git project, Gittory won't take any action, and you can continue with your work without any worries. If the current project is a Git project, Gittory will search in parent directories until it finds the `.git/` folder and then set the current working directory (cwd) to that location.


## Dependencies
Gittory don´t depends on other plugins, but it´s better with:
- [notify.nvim](https://github.com/rcarriga/nvim-notify)

## This plugin is useful when used with (it depends on your workflow)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) Gittory will expand the search scope of Telescope.
- [Harpoon](https://github.com/ThePrimeagen/harpoon) Gittory will allow you to better organize your Harpoon marks, being able to have the main ones at the root of your project, and when you deactivate Gittory, you can have marks in other cwd of your project.

## Installation
- This plugin doesn't have default keymaps.
- This plugin needs to be initialized with the 'setup' function.
- You can install Gittory using your preferred package manager. Here's an example using `lazy.nvim`:

```lua
return{
  {"IsWladi/Gittory",

    branch = "main", -- for tested version of the plugin

    dependencies = {
        {"rcarriga/nvim-notify"}, -- optional
    },
    config = true,
    opts = {
          notify = "yes", -- by default "yes"
          atStartUp = "yes" -- by default "yes"
    },
  }
}
```

## Plugin commands
`:GittoryInit` initializes Gittory and sets the current working directory (cwd) to the root of the git project (this command is not necessary if you have the option `atStartUp = "yes"`).

`:GittoryDesactivate` Deactivates Gittory and sets the initial path where Neovim was opened.

## Contributing
If you would like to contribute to the development of Gittory, you can do so by submitting a pull request or opening an issue on the project’s GitHub repository.
