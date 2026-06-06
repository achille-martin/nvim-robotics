# Nvim Robotics

Neovim configuration. Optimised for Robotics Engineers.

<a id="overview"></a>
## 1. Overview

### 1.1. What is Neovim?

[Neovim](https://github.com/neovim/neovim) is a text editor engineered for extensibility and usability.

The main motivations of Neovim are:
* Retain the character and philosophy of [Vim](https://github.com/vim/vim) editor: speed, versatility, minimalism.
* Encourage new cross-platform applications while focusing on modularity: native [Lua](https://www.lua.org/about.html) support enables smoother plugin development.
* Promote contributions from new and seasoned authors by making the editor accessible.

### 1.2. Is this repo only for Robotics Engineers?

Not really!

Some [requirements](docs/requirements.md) have been defined to provide an optimised configuration of Neovim for Robotics Engineers; however, the repo [nvim-robotics](https://github.com/achille-martin/nvim-robotics) can be used by anyone who wants to discover the Neovim editor and develop their personal "writing/coding environment".

## 2. Configuration

<a id="pre-requisites"></a>
### 2.1. Pre-requisites

Make sure that Neovim is operational on your machine by typing the following command in a terminal:

```bash
nvim --version
```

:warning: If Neovim is not functional, or if your Neovim version is lower than `v0.12.0`, refer to [Neovim setup](docs/neovim_setup.md) to unlock all functionalities of Neovim.

<a id="quick-config-setup"></a>
### 2.2. Quick configuration setup

:point_right: The quick-setup configuration does not interfere with your existing Neovim configuration.

Apply the quick-setup configuration by typing the following command in a terminal:

```bash
sudo apt-get install curl -y &&
curl "https://raw.githubusercontent.com/achille-martin/nvim-robotics/refs/heads/main/scripts/nvim_config_manager.sh" --create-dirs --output "/tmp/nvim-robotics/nvim_config_manager.sh" &&
curl "https://raw.githubusercontent.com/achille-martin/nvim-robotics/refs/heads/main/scripts/helper_functions.sh" --create-dirs --output "/tmp/nvim-robotics/helper_functions.sh" &&
chmod +x "/tmp/nvim-robotics/nvim_config_manager.sh" &&
chmod +x "/tmp/nvim-robotics/helper_functions.sh" &&
"/tmp/nvim-robotics/nvim_config_manager.sh" quick-setup
```

You can now launch Neovim with the [nvim-robotics](https://github.com/achille-martin/nvim-robotics) configuration by using the default aliases set:

```bash
# Primary alias
nvim-robotics
```

```bash
# Secondary alias
neo
```

### 2.3. Custom configuration setup

If you wish to craft your own Neovim configuration, refer to [custom configuration setup](docs/custom_configuration_setup.md).

## 3. Support

If you enjoy this Neovim configuration, or found some interesting settings, let me know by clicking the button below:

<!-- Buy me a coffee link -->
<a href="https://www.buymeacoffee.com/achille_martin">
  <img src="https://img.buymeacoffee.com/button-api/?text=Buy+me+a+coffee&emoji=&slug=achille_martin&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff"/>
</a>
