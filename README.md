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

The project is in a mature development phase, with the core functionalities complete. I am not planning to add new features but will address bugs and issues if they arise. This project follows the KISS principle, prioritizing simplicity and stability. I still welcome feedback and contributions from the community for ongoing improvement.

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
            -- "print" it will print messages to the command line.
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

- `:Gittory init`: Initializes Gittory and sets the current working directory (cwd) to the root of the Git project. This command is not required if you have set the option `atStartUp = true`.

- `:Gittory finish`: Restores the initial working directory to the path where Neovim was originally opened, effectively deactivating Gittory.

- `:Gittory toggle`: Toggles Gittory between its active state (root of the Git project) and inactive state (initial working directory).

- `:Gittory root`: Manually restores the working directory to the root of the Git project.

- `:Gittory backup`: Restores the initial working directory to the state it was in when NeoVim was launched.

For more detailed documentation about Gittory, you can use the command `:help gittory` within Neovim.

## Contributing

If you would like to contribute to the development of Gittory, you can do so by submitting a pull request or opening an issue on the project’s GitHub repository.
