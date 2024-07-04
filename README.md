# terminal

# Setting up a new computer

1. Clone this repo
2. Create a `.zshrc.local` file in the root dir to keep local config
3. Add this to `.zshrc.local` file:

```sh
export LOCAL_GIT_REPO_PATH="/path/to/git/repos/on/this/computer"
```

4. Install `Hack Nerd Font` from [this site](https://www.nerdfonts.com/font-downloads)
5. Run `source ~/.zshrc.local && source ~/.zshrc && deps`

# Adding new things

1. Go to where this git repo is cloned
2. Create whatever file or folder you would like to add (`touch foo.txt`, etc)
3. Run `deps` to ensure a symlink is created
