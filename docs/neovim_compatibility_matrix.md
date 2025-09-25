# Neovim compatibility matrix

The following compatibility matrix introduces the version limitations for the core components required for the [nvim-robotics](https://github.com/achille-martin/nvim-robotics) repo.

As a general note, it is recommended to install the latest Neovim version available for your Operating System (OS) so that you can benefit from all the functionalities of the [nvim-robotics](https://github.com/achille-martin/nvim-robotics) configuration.

| Entity | OS | Flavour | Min requirements for OS <br>(for a functional neovim) | Default version of neovim | Max version of neovim <br>(not functional after that) |
| --- | --- | --- | --- | --- | --- |
| `neovim` | Linux | `Ubuntu18.04` | \* kernel >= 2.6.32<br>\* glibc >= 2.12 | \* stable neovim [version 0.2.2](https://github.com/neovim/neovim/releases/tag/v0.2.2) provided by apt package | \* last stable neovim [version 0.9.5](https://github.com/neovim/neovim/releases/tag/v0.9.5/) because glibc = 2.27 on `Ubuntu18.04`<br><br>For the latest unsupported releases of neovim (working on `Ubuntu18.04` and normally requiring glibc >= 2.31), refer to [neovim-releases](https://github.com/neovim/neovim-releases/releases)  |
| `neovim` | Linux | `Ubuntu22.04` | \* kernel >= 2.6.32<br>\* glibc >= 2.35 | \* stable neovim [version 0.6.1](https://github.com/neovim/neovim/releases/tag/v0.6.1) provided by apt package | \* latest stable neovim accessible from [the neovim releases page](https://github.com/neovim/neovim/releases) because glibc >= 2.31 requirement is satisfied (for now)  |
| `neovim` | Linux | `Ubuntu24.04` | \* kernel >= 2.6.32<br>\* glibc >= 2.35 | \* stable neovim [version 0.9.5](https://github.com/neovim/neovim/releases/tag/v0.9.5/) provided by apt package | \* latest stable neovim accessible from [the neovim releases page](https://github.com/neovim/neovim/releases) because glibc >= 2.31 requirement is satisfied (for now)  |

