# Custom configuration setup

If you wish to craft your own Neovim configuration, while using [nvim-robotics](https://github.com/achille-martin/nvim-robotics) as a base:
* Fork the [nvim-robotics](https://github.com/achille-martin/nvim-robotics) repo
* Make sure that Neovim is operational on your machine, as detailed in the [quick configuration setup](../README.md#quick-config-setup)
* Download the [configuration manager](../scripts/nvim_config_manager.sh) along with the [helper functions](../scripts/helper_functions.sh) via the following command (replacing the placeholders for your forked repo and for the branch in the url):

```bash
sudo apt-get install curl -y &&
curl "https://raw.githubusercontent.com/<forked_repo>/refs/heads/<branch>/scripts/nvim_config_manager.sh" --create-dirs --output "/tmp/nvim-robotics/nvim_config_manager.sh" &&
curl "https://raw.githubusercontent.com/<forked_repo>/refs/heads/<branch>/scripts/helper_functions.sh" --create-dirs --output "/tmp/nvim-robotics/helper_functions.sh" &&
chmod +x "/tmp/nvim-robotics/nvim_config_manager.sh" &&
chmod +x "/tmp/nvim-robotics/helper_functions.sh"
```

* Run the following command to generate your custom configuration (replacing the config name with your desired config name):

```bash
"/tmp/nvim-robotics/nvim_config_manager.sh" quick-setup <your_config_name>
```

You can now launch Neovim with the forked repo configuration by using the alias you have defined above:

```bash
<your_config_name>
```

You can also launch Neovim with the forked repo configuration by using a practical alias set:

```bash
neo
```
