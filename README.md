# Gittory

<a href="https://dotfyle.com/plugins/IsWladi/Gittory">
  <img src="https://dotfyle.com/plugins/IsWladi/Gittory/shield" />
</a>

Effortlessly Root Your Workspace – Wherever You Wander in Your Code!

## Table of Contents

- [Project status](#project-status)
- [Introduction](#introduction)
  - [This plugin is useful when used with](#this-plugin-is-useful-when-used-with)
- [Installation](#installation)
  - [Installation with lazy.nvim](#installation-with-lazynvim)
- [Usage](#usage)
  - [Plugin commands](#plugin-commands)
- [Contributing](#contributing)

## Project status

The project is currently in an experimental phase with a Minimal Viable Product (MVP) established on the main branch. Core functionalities are in place, and I am actively developing new and exciting features on separate branches. These features will remain under development until they reach a polished state worthy of integration into the final version of the plugin. Anticipate significant (breaking changes) updates when these new features are released.

Upcoming enhancements include customizable root patterns, potential integration of a popup interface, and the ability to switch between different project scopes (e.g., Node.js, Python, etc.).

Your feedback is invaluable to this open-source project, and all suggestions are thoughtfully considered. I encourage the community to contribute their insights for the continuous evolution of this project.

## Introduction

Gittory is a straightforward and useful NeoVim plugin. When you open NeoVim, it checks if you're in a Git repository and sets your current working directory (cwd) to the root of your project, where the `.git/` directory is located.

### This plugin is useful when used with

- [Telescope](https://github.com/nvim-telescope/telescope.nvim) Gittory enhances Telescope by broadening your search scope to include the entire project, regardless of the subfolder from where you launched NeoVim.
- [Harpoon](https://github.com/ThePrimeagen/harpoon) With Gittory, managing your Harpoon marks becomes more efficient. Your marks are consistently set within the same project context—anchored at the project root. Even when Gittory is deactivated, your marks remain organized, adaptable to other working directories within your project.

## Installation

- This plugin doesn't have default keymaps.
- This plugin needs to be initialized with the 'setup' function.

### Installation with lazy.nvim

```lua
return{
  {"IsWladi/Gittory",

    branch = "main", -- for MVP version of the plugin

    dependencies = {
        {"rcarriga/nvim-notify"}, -- optional
    },
    opts = { -- you can omit this, is the default
          atStartUp = true, -- If you want to initialize Gittory when Neovim starts

          notifySettings = {
            enabled = true, -- This flag enables the notification system, allowing Gittory to send alerts about its operational status changes.

            -- rcarriga/nvim-notify serves as the default notification plugin. However, alternative plugins can be used, provided they include the <plugin-name>.notify(message) method.            -- you can change the order of priority for the plugins or remove those you don't use.
            -- If one of the specified notification plugins is not installed, the next one in the list will be used.
            -- "print" is the native notification plugin for Neovim; it will print messages to the command line.
            -- The "print" string is included for clarity. If removed, 'print' will still be used if the other specified plugins are not installed.
            availableNotifyPlugins =  {"notify", "print"} -- for example; you can use "fidget" instead of "notify"
          }
    },
  }
}
```

## Usage

With the default configuration, simply open NeoVim. Gittory will automatically and efficiently set your current working directory (CWD) to your project's `.git/` folder, requiring no additional action on your part.

### Plugin commands

- `:GittoryInit` initializes Gittory and sets the current working directory (cwd) to the root of the git project (this command is not necessary if you have the option `atStartUp = true`).
- `:GittoryDesactivate` Sets the initial path where Neovim was opened.

## Contributing

If you would like to contribute to the development of Gittory, you can do so by submitting a pull request or opening an issue on the project’s GitHub repository.
