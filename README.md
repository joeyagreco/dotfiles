# setting up a new computer

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
5. Run `source ~/.zshrc.local && source ~/zsh/init.zsh && make deps`

# upgrading neovim

1. check [releases page](https://github.com/neovim/neovim/releases)
2. check current version: `nvim -v`
3. update `brew update && brew upgrade nvim`
4. check current version: `nvim -v`

