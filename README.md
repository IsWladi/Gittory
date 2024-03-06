# <strong style="color: red;">GIT</strong> <strong style="color: grey;"> working direc</strong><strong style="color: red;">TORY</strong>
<a href="https://dotfyle.com/plugins/IsWladi/Gittory">
  <img src="https://dotfyle.com/plugins/IsWladi/Gittory/shield" />
</a>

## Gittory Table of Contents
- [Project status](#project-status)
- [Introduction](#introduction)
  * [This plugin is useful when used with](#this-plugin-is-useful-when-used-with)
- [Installation](#installation)
  * [Optional dependencies](#optional-dependencies)
  * [Installation with lazy.nvim](#installation-with-lazy.nvim)
- [Plugin commands](#plugin-commands)
- [Contributing](#contributing)

## Project status
The project has reached stability with all intended functionalities now implemented. It is currently in the maintenance phase. Feedback is appreciated, and any suggestions for new features will be thoughtfully considered. This is an open-source effort, and I invite community input for ongoing improvements.

## Introduction
Gittory is a straightforward and useful NeoVim plugin. When you open NeoVim, it checks if you're in a Git repository and sets your current working directory (cwd) to the root of your project, where the `.git/` directory is located.

### This plugin is useful when used with
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) Gittory enhances Telescope by broadening your search scope to include the entire project, regardless of the subfolder from where you launched NeoVim.
- [Harpoon](https://github.com/ThePrimeagen/harpoon) With Gittory, managing your Harpoon marks becomes more efficient. Your marks are consistently set within the same project context—anchored at the project root. Even when Gittory is deactivated, your marks remain organized, adaptable to other working directories within your project.

## Installation
- This plugin doesn't have default keymaps.
- This plugin needs to be initialized with the 'setup' function.

### Optional dependencies
Gittory does not depend on other plugins to function. However, for enhanced visual notifications, you might consider complementing it with [notify.nvim](https://github.com/rcarriga/nvim-notify) for rich, customizable notification popups or with [fidget.nvim](https://github.com/j-hui/fidget.nvim) while mainly a tool for LSP status notifications, can be repurposed to serve as a minimalist notifier for Gittory events, offering a subtle notification experience.

### Installation with lazy.nvim
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

`:GittoryDesactivate` Desactivates Gittory and sets the initial path where Neovim was opened.

## Contributing
If you would like to contribute to the development of Gittory, you can do so by submitting a pull request or opening an issue on the project’s GitHub repository.
