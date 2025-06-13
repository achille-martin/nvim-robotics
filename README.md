# Robotics Nvim

Neovim configuration optimised for Robotics Engineers.

## Requirements

| ID | Requirement | Value | MoSCoW | Comments |
| --- | --- | --- | --- | --- |
| R1 | Be installable on common computer boards used in Robotics | Based on the Raspberry Pi with a simple SD card of 32GB, the total size of the neovim installation (including dependencies) is < 100MB (i.e. less than 1% of storage capacity) | MUST | Strict storage space limits |
| R2 | Be installable on common operating systems | Common operating systems include: Linux, Windows, MacOS | MUST | Priority given to Linux (and particularly Ubuntu, starting from `Ubuntu18.04`) because that is the preferred OS in Robotics. Note that there might be issues related to access of latest releases because the OS distribution might be too old or unmaintained.<br><br>Focus on Windows as well because sensor interfaces are usually distributed as Windows applications. |
| R3 | Manipulate large files efficiently | Open, edit and refresh (tail) large log files of max 2GB (i.e. half of RAM available on standard computer board for Robotics) | MUST | Log files in ROS can get heavy pretty quickly and quick debugging is essential |
| R4 | Be highly customisable by users | Customisable = format, style, layout, shortcuts, language specifics | MUST | Every engineer is different and has a different way of working. Installation can be done through a commonly used language for Robotics Engineers: `bash`. |
| R5 | Handle common Robotics Programming entities | Minimum Robotics Programming entities (in order of priority) = `bash`, `python`, `cpp`, `ros`, `ros2` `markdown`, `html`, `matlab`, `git` | MUST | Handling programming entities means: autocomplete, suggestions, documentation when available, reference search, formatting, linting, debugging |
| R6 | Integrate convenient terminal access | Access to terminal is directly in the environment of development and one window can handle a maximum of 4 terminals at once | MUST | Terminals are commonly used to interact with Robotics Systems |
| R7 | Search efficiently through large folders | Size of large folder is max 16GB (i.e. half of the space available on common computer boards) | MUST | Robotics environments are usually centred around a unique folder architecture. This folder contains the source code of the various applications and can take up space depending on coding practices |
| R8 | Withstand long periods of programming sessions | Long programming session = 4 hours (i.e. half a day) | SHOULD | Usually a text editor is used for short periods of time, but if we want a robust IDE we need to make sure that it will remain reliable for a long time |

