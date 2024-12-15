# dotfiles 

# Setting up a new computer

1. Clone this repo
2. Create a `.zshrc.local` file in the root dir to keep local config
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

