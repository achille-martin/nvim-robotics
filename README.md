# Nvim Robotics

Neovim configuration, optimised for Robotics Engineers.

<a id="overview"></a>
## 1. Overview

### 1.1. What is Neovim?

[Neovim](https://github.com/neovim/neovim) is a text editor engineered for extensibility and usability.

The main motivations of Neovim are:
* Retain the character and philosophy of [Vim](https://github.com/vim/vim) editor: speed, versatility, minimalism.
* Encourage new cross-platform applications while focusing on modularity (thanks to native [Lua](https://www.lua.org/about.html) support for plugin development)
* Promote contributions from new and seasoned authors

Neovim is a continuation and extension of the Vim editor, which is an "improved" version of the [Vi](https://man7.org/linux/man-pages/man1/vi.1p.html) editor, which itself is an accessible and ubiquitous character-based screen editor without a Graphical User Interface.

### 1.2. Is it only for Robotics Engineers?

The [nvim-robotics](https://github.com/achille-martin/nvim-robotics) repo provides an optimised configuration of Neovim for Robotics Engineers, based on the following [requirements](docs/requirements.md).

However, the repo can be used by anyone who wants to discover the Neovim editor and develop their personal "writing/coding environment".

## 2. Configuration

<a id="quick-config-setup"></a>
### 2.1. Quick configuration setup

First of all, make sure that Neovim is operational on your machine by typing `nvim` in a terminal. If it is not functional, refer to [Neovim setup](docs/neovim_setup.md).

**Note: rest assured that, if you have already created a personal configuration for Neovim, the following quick configuration setup will not affect it.**

Once Neovim is operational, download the [configuration manager](scripts/nvim_config_manager.sh) and then run the following command from the folder containing the script:

```bash
bash nvim_config_manager.sh quick-setup
```

You can now launch Neovim with the repo configuration by using the default alias set:

```bash
nvim-robotics
```

You can also launch Neovim with the repo configuration by using a practical alias set:

```bash
neo
```

### 2.2. Custom configuration setup

If you wish to craft your own configuration, while using [nvim-robotics](https://github.com/achille-martin/nvim-robotics) as a base:
* Fork the [nvim-robotics](https://github.com/achille-martin/nvim-robotics) repo
* Make sure that Neovim is operational on your machine, as detailed in the [quick configuration setup](README.md#quick-config-setup)
* Download the [configuration manager](scripts/nvim_config_manager.sh) and then run the following command from the folder containing the script:

```bash
bash nvim_config_manager.sh quick-setup <your_config_name>
```

You can now launch Neovim with the forked repo configuration by using the alias you have defined above:

```bash
<your_config_name>
```

You can also launch Neovim with the forked repo configuration by using a practical alias set:

```bash
neo
```

