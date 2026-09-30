# The-Abe Dotfiles

All dotfiles are managed with chezmoi. Files and config outside of the home dir
are managed with scripts in the `.chezmoiscripts` directory. Note the OS
conditionals in the directories. Just putting something in the `arch` dir will
not magically make it only run on Arch.

## Installation

Installation is done by installing and running Chezmoi. There's no reason to
clone this repo directly.

```sh
sh -c "$(curl -fsSL get.chezmoi.io)" -- init --apply The-Abe/dotfiles
```

The repo is public so this should work anywhere.

## Packages

Required packages are installed in the `.chezmoiscripts` scripts depending on
OS. Other distinctions for packages are made with env vars such as
`GUITAR_MODE` to install packages required for DAW, NAM, audio etc..
