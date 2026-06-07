## Setting up a new computer

1. Clone this repo
2. Create a `.zshrc.local` file in ~
3. Add this to `.zshrc.local` file:

```sh
# path to git repos on [this] computer
export LOCAL_GIT_REPO_PATH="/path/to/git/repos/on/this/computer"
# github prefix (profile name OR org name)
# example: https://github.com/{THIS_IS_THE_VALUE_YOU_WANT}/{SOME_REPO}.git
export GITHUB_PREFIX="my_github_profile_or_org"
```

4. Install `JetBrainsMono Nerd Font` from [this site](https://www.nerdfonts.com/font-downloads)
5. Run `make links`
5. Run `source ~/.zshrc.local && source ~/.config/zsh/init.zsh && make deps`


## Version Updates
### Check for outdated versions
`make check-versions`

### Installing/updating alacritty
1. Download the latest stable `.dmg` file from the [github releases page](https://github.com/alacritty/alacritty/releases)

### Upgrading neovim
1. Check [releases page](https://github.com/neovim/neovim/releases) to see the latest version
1. Set version `mise use neovim@{VERSION}`

### Upgrading tmux
1. Check the [releases page](https://github.com/tmux/tmux/releases) to see the latest version

### Upgrading starship
1. Check the [releases page](https://github.com/starship/starship/releases) to see the latest version
2. Upgrade with `brew update && brew upgrade starship`

### Upgrading hammerspoon
1. Check the [releases page](https://github.com/Hammerspoon/hammerspoon/releases) to see the latest version
2. Upgrade with `brew update && brew upgrade --cask hammerspoon`
