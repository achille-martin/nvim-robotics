# Custom configuration setup

If you wish to craft your own Neovim configuration, while using [nvim-robotics](https://github.com/achille-martin/nvim-robotics) as a base:
* Fork the [nvim-robotics](https://github.com/achille-martin/nvim-robotics) repo
* Make sure that Neovim is operational on your machine, as detailed in the [quick configuration setup](README.md#quick-config-setup)
* Download the [configuration manager](scripts/nvim_config_manager.sh) along with the [helper functions](scripts/helper_functions.sh) and then run the following command from the folder containing the scripts:

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
