# Gittory
<a href="https://dotfyle.com/plugins/IsWladi/Gittory">
  <img src="https://dotfyle.com/plugins/IsWladi/Gittory/shield" />
</a>

## Project status
This project is in stage of development. Although it is already fully functional. Any feedback on the plugin’s performance is appreciated.

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

## Dependencies
Gittory does not depend on other plugins to function. However, for enhanced visual notifications, you might consider complementing it with:
- [notify.nvim](https://github.com/rcarriga/nvim-notify) for rich, customizable notification popups.
- [fidget.nvim](https://github.com/j-hui/fidget.nvim) while mainly a tool for LSP status notifications, can be repurposed to serve as a minimalist notifier for Gittory events, offering a subtle notification experience.
## This plugin is useful when used with
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
        {"j-hui/fidget.nvim"} -- optional
    },
    config = true,

    opts = { -- you can omit this, is the default
          atStartUp = true, -- If you want to initialize Gittory when Neovim starts

          notifySettings = {
            enabled = true, -- This flag enables the notification system, allowing Gittory to send alerts about its operational status changes.

            -- you can change the order of priority for the plugins or remove those you don't use.
            -- These are the available options. If you prefer a different notification plugin, please let me know by creating an issue.
            -- If one of the specified notification plugins is not installed, the next one in the list will be used.
            -- "print" is the native notification plugin for Neovim; it will print messages to the command line.
            -- The "print" string is included for clarity. If removed, 'print' will still be used if the other specified plugins are not installed.
            availableNotifyPlugins =  {"notify", "fidget", "print"}
          }
    },
  }
}
```
- For more documentation, see the neovim help `:help gittory-docs`

## Plugin commands
`:GittoryInit` initializes Gittory and sets the current working directory (cwd) to the root of the git project (this command is not necessary if you have the option `atStartUp = true`).

`:GittoryDesactivate` Deactivates Gittory and sets the initial path where Neovim was opened.

## Contributing
If you would like to contribute to the development of Gittory, you can do so by submitting a pull request or opening an issue on the project’s GitHub repository.
