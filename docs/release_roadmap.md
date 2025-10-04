# Release Roadmap

This note presents the list of releases with features (and implementation) included.

## Version 1.0.0

| Entity | Value |
| --- | --- |
| Version | 1.0.0 |
| Purpose | Setup a basic Neovim IDE interface |
| Release date | Unknown |

| F# | Capability | Comments | Req# | Implementation# | Description | Challenges | Decision | Progress State |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| F1 | Install and setup Neovim | \* Easier to on-board users new to Neovim<br>\* Focus on most common Operating System in Robotics (Linux - Ubuntu) | R2 | I1.1 | Create a utility to manage the installation / uninstallation of Neovim | \* Supporting a wide range of OS and evolving software | OK | DONE |
| | | | | I1.2 | Refer to the official Neovim installation instructions in documentation | | OK | DONE |
| F2 | Install and setup default configuration | \* Simpler to only manage a unique basic configuration that can be tweaked later on by users | R1 | I2.1 | Create a utility to manage setup and cleanup of the default configuration | | OK | DONE |
| | | | | I2.2 | Improve the utility to setup and cleanup a custom configuration | \* Supporting a fully customisable configuration | MAYBE | DONE (LIMITED) |
| F3 | Organise documentation | \* Easier to on-board new users<br>\* Keep the documentation brief and organised | R4 | I1.1 | Create a separate `docs` folder to keep documentation tidy | \* Maintaining the documentation | OK | DONE (BASIC) |

