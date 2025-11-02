# Neovim setup

## Recommended installation

To setup Neovim on your machine, it is recommended to download the custom installer script and then run it, via the following command:

```bash
sudo apt-get install curl &&
curl "https://raw.githubusercontent.com/achille-martin/nvim-robotics/refs/heads/main/scripts/nvim_installer.sh" --create-dirs --output "/tmp/nvim-robotics/nvim_installer.sh" &&
curl "https://raw.githubusercontent.com/achille-martin/nvim-robotics/refs/heads/main/scripts/helper_functions.sh" --create-dirs --output "/tmp/nvim-robotics/helper_functions.sh" &&
bash "/tmp/nvim-robotics/nvim_installer.sh" install
```

You can confirm that Neovim has been properly installed by running `nvim` in a terminal.

## Troubleshooting

If your Operating System is not supported, according to the [compatibility matrix](../docs/neovim_compatibility_matrix.md), the custom installer script will try to install the unsupported release of Neovim. However, this may fail and you might need to manually debug the installation using the logs provided by the script.

If you prefer, you can follow the [official installation instructions](https://github.com/neovim/neovim/blob/master/INSTALL.md) to install Neovim.

## Going further

If you are new to Neovim, check out [this tutorial from Richard Callaby](https://github.com/rcallaby/Learn-Vim-and-NeoVim).

