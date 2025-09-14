# Nvim Robotics

Neovim configuration optimised for Robotics Engineers.

<a id="overview"></a>
### What is Neovim?

[Neovim](https://github.com/neovim/neovim) is a text editor engineered for extensibility and usability.

The main motivations of Neovim are:
* Encourage new applications on any platform while focusing on modularity (thanks to native [Lua](https://www.lua.org/about.html) support for plugin development)
* Promote contributions from new and seasoned authors
* Retain the character and philosophy of [Vim](https://github.com/vim/vim) editor: speed, versatility, minimalism.

Neovim is indeed a continuation and extension of Vim editor, which is an "improved" version of the [Vi](https://man7.org/linux/man-pages/man1/vi.1p.html) editor, which itself is an accessible and ubiquitous character-based screen editor without a Graphical User Interface (GUI).

### Is it only for Robotics Engineers?

[nvim-robotics](https://github.com/achille-martin/nvim-robotics) provides an optimised configuration of Neovim for Robotics Engineers (based on the following [requirements](README.md#requirements)), but the repo can be used by anyone who wants to discover Neovim editor and develop their personal "coding environment".

<a id="toc"></a>
## Table of Contents

* [Overview](#overview)
* [1. Requirements](#requirements)
* [2. Compatibility matrix](#compatibility-matrix)
* [3. Configuration setup](#config-setup)
    * [3.1. Quick setup](#quick-config-setup)
    * [3.2. Custom setup](#custom-config-setup)
    * [3.3. Config management](#custom-config-management)

<a id="requirements"></a>
## 1. Requirements

| ID | Requirement | Value | MoSCoW | Comments |
| --- | --- | --- | --- | --- |
| R1 | Be installable on common computer boards used in Robotics | Based on the Raspberry Pi with a simple SD card of 32GB, the total size of the neovim installation (including dependencies) is < 100MB (i.e. less than 1% of storage capacity) | MUST | Strict storage space limits |
| R2 | Be installable on common operating systems | Common operating systems include: <br>\* Linux<br>\* Windows<br>\* MacOS | MUST | Priority given to Linux (and particularly Ubuntu, starting from `Ubuntu18.04`) because that is the preferred OS in Robotics. Note that there might be issues related to access of latest releases because the OS distribution might be too old or unmaintained.<br><br>Focus on Windows as well because sensor interfaces are usually distributed as Windows applications. |
| R3 | Manipulate large files efficiently | Open, edit and refresh (tail) large log files of max 2GB (i.e. half of RAM available on standard computer board for Robotics) | MUST | Log files in ROS can get heavy pretty quickly and efficient debugging is essential |
| R4 | Be highly customisable by users | Customisable = format, style, layout, shortcuts, language specifics | MUST | Every engineer is different and has a different way of working. <br><br>Installation can be done through a commonly used language for Robotics Engineers: `bash`. |
| R5 | Handle common Robotics Programming entities | Minimum Robotics Programming entities (in order of priority) =<br>\* `bash`<br>\* `python`<br>\* `cpp`<br>\* `ros`<br>\* `markdown`<br>\* `html`<br>\* `matlab`<br>\* `git` | MUST | Handling programming entities means: autocomplete, suggestions, documentation, reference search, formatting, linting, debugging |
| R6 | Integrate convenient terminal access | Access to terminal is directly in the environment of development and one window can handle a maximum of 4 terminals at once | MUST | Terminals are commonly used to interact with Robotics Systems |
| R7 | Search efficiently through large folders | Size of large folder is max 16GB (i.e. half of the space available on common computer boards) | MUST | Robotics environments are usually centred around a unique folder architecture. This folder contains the source code of the various applications and can take up space depending on coding practices |
| R8 | Withstand long periods of programming sessions | Long programming session = 4 hours (i.e. half a working day) | SHOULD | Usually a text editor is used for short periods of time, but if we want a robust IDE, we need to make sure that it will remain reliable for a long time |
| R9 | Display information reliably and with limited lag | Acceptable startup time < 2 seconds; Maximum lag acceptable for inputs < 0.1 second | SHOULD | The reliability and lag of the display might be a limitation of the specifications of the machine, but still, the editor should be capable to meet the startup and max lag requirements for smooth enough interaction in the worst case. |

<a id="compatibility-matrix"></a>
## 2. Compatibility matrix

| Entity | OS | Flavour | Min requirements for OS <br>(for a functional neovim) | Default version of neovim | Max version of neovim <br>(not functional after that) |
| --- | --- | --- | --- | --- | --- |
| `neovim` | Linux | `Ubuntu18.04` | \* kernel >= 2.6.32<br>\* glibc >= 2.12 | \* stable neovim [version 0.2.2](https://github.com/neovim/neovim/releases/tag/v0.2.2) provided by apt package | \* last stable neovim [version 0.9.5](https://github.com/neovim/neovim/releases/tag/v0.9.5/) because glibc = 2.27 on `Ubuntu18.04`<br><br>For the latest unsupported releases of neovim (working on `Ubuntu18.04` and normally requiring glibc >= 2.31), refer to [neovim-releases](https://github.com/neovim/neovim-releases/releases)  |
| `neovim` | Linux | `Ubuntu22.04` | \* kernel >= 2.6.32<br>\* glibc >= 2.35 | \* stable neovim [version 0.6.1](https://github.com/neovim/neovim/releases/tag/v0.6.1) provided by apt package | \* latest stable neovim accessible from [the neovim releases page](https://github.com/neovim/neovim/releases) because glibc >= 2.31 requirement is satisfied (for now)  |
| `neovim` | Linux | `Ubuntu24.04` | \* kernel >= 2.6.32<br>\* glibc >= 2.35 | \* stable neovim [version 0.9.5](https://github.com/neovim/neovim/releases/tag/v0.9.5/) provided by apt package | \* latest stable neovim accessible from [the neovim releases page](https://github.com/neovim/neovim/releases) because glibc >= 2.31 requirement is satisfied (for now)  |

<a id="config-setup"></a>
## 3. Configuration setup

<a id="quick-config-setup"></a>
### 3.1. Quick setup

Once [Neovim is installed](https://github.com/neovim/neovim/blob/master/INSTALL.md) and working, you can use the nvim robotics configuration straight away by typing the following commands in your terminal (**this step will not affect your existing configurations**):

* Define a handy function to setup the nvim config:

```bash
nvim_quick_config_setup() {

    # Warn the user that the process is starting
    printf "Quick setup of nvim robotics configuration...\n" &&
    
    # Confirm the installation of nvim
    [[ $(which nvim) ]] &&
    
    # Define handy variables
    DEFAULT_CONFIG_FOLDER="$HOME/.config" &&
    if [[ -z "$1" ]]
    then
        DEFAULT_CONFIG_NAME="nvim-robotics";
    else
        DEFAULT_CONFIG_NAME="$1";
    fi &&
    DEFAULT_LOADER_SCRIPT_NAME="nvim_loader.sh" &&
    DEFAULT_ALIAS="$DEFAULT_CONFIG_NAME" &&
    
    # Store the configuration in a specific folder for nvim to find it
    git clone git@github.com:achille-martin/nvim-robotics.git "$DEFAULT_CONFIG_FOLDER/$DEFAULT_CONFIG_NAME" &&
    
    # Create a link to the nvim loader script (force overwrite if existing)
    ln -sf "$DEFAULT_CONFIG_FOLDER/$DEFAULT_CONFIG_NAME/scripts/$DEFAULT_LOADER_SCRIPT_NAME" "$DEFAULT_CONFIG_FOLDER/$DEFAULT_LOADER_SCRIPT_NAME" &&
    
    # Create the alias for the nvim robotics config (making sure it does not exist already)
    [[ ! ${BASH_ALIASES[$DEFAULT_ALIAS]} ]] &&
    printf "alias $DEFAULT_ALIAS=\"$DEFAULT_CONFIG_FOLDER/$DEFAULT_LOADER_SCRIPT_NAME --custom-config '$DEFAULT_ALIAS'\"" >> $HOME/.bash_aliases &&
    
    # Warn the user that the process is done
    printf "...Done\n"

}
```

* Launch the config setup process with:

```bash
nvim_quick_config_setup
```

* If the word "Done" appeared in your terminal, you can now launch nvim with the robotics config using the default alias set:

```bash
nvim-robotics
```

<a id="custom-config-setup"></a>
### 3.2. Custom setup

If you prefer working on your own nvim configuration (non-git folder or custom git management), while using the nvim robotics configuration as a base, get inspiration from [Quick setup](#quick-setup) and adapt the variables / steps.

As an example, with alias `nvim-me`:

* Define an adjusted version of the function to setup the nvim config:

```bash
nvim_custom_config_setup() {

    # Warn the user that the process is starting
    printf "Custom setup of nvim robotics configuration...\n" &&

    # Setup quick config as a start
    nvim_quick_config_setup "$1"
  
    # Remove .git elements to replace with own versioning tool
    cd "$DEFAULT_CONFIG_FOLDER/$DEFAULT_CONFIG_NAME" &&
    rm -rf ".git" &&
    
    # Warn the user that the process is done
    printf "...Done\n"

}
```

* Launch the config setup process with:

```bash
nvim_custom_config_setup "nvim-me"
```

* If the word "Done" appeared in your terminal (twice), you can now launch nvim with the robotics config using the default alias set:

```bash
nvim-me
```

<a id="custom-config-management"></a>
### 3.3. Config management

If you want to switch easily between different custom configurations, you can setup a generic alias for the nvim loader:

* Define a handy function to set a generic alias for the nvim loader:

```bash
set_alias_for_nvim_loader() {

    # Warn the user that the process is starting
    printf "Generic alias setup for management of nvim robotics configuration...\n" &&
    
    # Set the generic alias
    GENERIC_ALIAS="$1" &&
    [[ ! ${BASH_ALIASES[$GENERIC_ALIAS]} ]] &&
    printf "alias $GENERIC_ALIAS=\"$DEFAULT_CONFIG_FOLDER/$DEFAULT_LOADER_SCRIPT_NAME\"" >> $HOME/.bash_aliases &&
    
    # Warn the user that the process is done
    printf "...Done\n"

}
```

* Launch the config setup process with:

```bash
set_alias_for_nvim_loader "neovim"
```

* If the word "Done" appeared in your terminal, you can now launch any custom nvim config (placed in `$HOME/.config`) using the generic alias set:

```bash
neovim --custom-config "nvim-me"
```
