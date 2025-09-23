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
credit to this [guide](https://dineshpandiyan.com/blog/install-neovim-macos/) for inspiration

## new way (with downloaded local versions)
1. check [releases page](https://github.com/neovim/neovim/releases)
2. check current version: `nvim -v`
3. run `xattr -c ./nvim-macos-arm64.tar.gz` (to avoid "unknown developer" warning)
4. `tar xzvf nvim-macos-arm64.tar.gz`
5. create a new directory for the version `mkdir {dotfiles_root}/bin/nvim/{new_version}`
6. copy to bin dir `cp -r ~/Downloads/nvim-macos-arm64/* ~/bin/nvim/{nvim_version_named_folder}/`
7. now running `~/bin/nvim/{nvim_version_named_folder}/bin/nvim` should run nvim

## old way (with brew)
1. check [releases page](https://github.com/neovim/neovim/releases)
2. check current version: `nvim -v`
3. update `brew update && brew upgrade nvim`
4. check current version: `nvim -v`
