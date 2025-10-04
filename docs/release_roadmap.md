# Release Roadmap

This note presents the list of releases with features (and implementation) included.

## Version 1.0.0

| Entity | Value |
| --- | --- |
| Version | 1.0.0 |
| Purpose | Setup a basic Neovim IDE interface |
| Release date | Unknown |

| F# | Capability | Comments | Req# | Impl# | Description | Challenges | Decision | Progress State |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| F1 | Install and setup Neovim | \* Easier to on-board users new to Neovim<br>\* Focus on most common Operating System in Robotics (Linux - Ubuntu) | R2 | I1.1 | Create a utility to manage the installation / uninstallation of Neovim | \* Supporting a wide range of OS and evolving software | OK | DONE |
| | | | | I1.2 | Refer to the official Neovim installation instructions in documentation | | OK | DONE |
| F2 | Install and setup default configuration | \* Simpler to only manage a unique basic configuration that can be tweaked later on by users | R1, R4 | I2.1 | Create a utility to manage setup and cleanup of the default configuration | | OK | DONE |
| | | | | I2.2 | Improve the utility to setup and cleanup a custom configuration | \* Supporting a fully customisable configuration | MAYBE | DONE (LIMITED) |
| F3 | Access clear documentation | \* Easier to on-board new users<br>\* Keep the documentation brief and organised | R4 | I3.1 | Create a separate `docs` folder to keep documentation tidy | \* Maintaining the documentation | OK | DONE (BASIC) |
| F4 | Interact with a usable interface | \* Define global settings to make Neovim usable, even for new users | R1, R2 | I4.1 | Select a basic set of options / global settings | \* Picking relevant options while not altering the essence of Neovim | OK | IN PROGRESS |
| F5 | Interact with a readable interface | \* Use colours and highlights to make common visual features stand out | R8, R9 | I5.1 | Create a basic colorscheme config | \* Picking a colorsscheme readable by all users | OK | TODO |
| F6 | Perform complex edition operations quickly | \* Rely on third-party plugins to make complex operations easy | R3, R6, R7 | I6.1 | Select necessary third-party plugins to improve usage performance (and create a basic config for them) | \* Picking only relevant plugins while avoiding bloating the interface | OK | TODO |
| F7 | Interact with programming languages with minimal friction | \* Support a wide range of programming language actions, relevant for Robotics Engineers | R5 | I7.1 | Create a basic config for common programmig languages through the Language Server Protocol | \* Picking languages to support<br>\* Maintaining support for picked languages<br>\* Investigating and solving LSP implementation issues / limitations | OK | TODO |
| F8 | Interact with the interface in a familiar / universal way | \* Define key mappings to enable quick transfer from other editors to Neovim | R1, R2 | I8.1 | Create a basic set of key mappings shared across the Software Community | \* Picking universal key mappings while not altering the Neovim capabilities | OK | TODO |
| F9 | Get in control of the basic configuration | \* Give control to new and seasoned users to tweak the basic configuration to their liking | R4 | I9.1 | Define toggles and customisation management utilities | \* Enable fully custom configuration while ensuring that the repo is maintainable | MAYBE | N/A |
