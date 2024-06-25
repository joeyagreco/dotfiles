# terminal

# Setting up a New Computer

1. Clone this repo
2. Create a `.zshrc.local` file in the root dir to keep local config
3. Add this to `.zshrc.local` file:

```sh
export LOCAL_GIT_REPO_PATH="/path/to/git/repos/on/this/computer"
```

4. Run `source .zshrc.local && applyz`
5. Install dependencies `deps`
6. Install `Hack Nerd Font` from [this site](https://www.nerdfonts.com/font-downloads)

# Adding new things

1. Go to where the git repo is cloned
2. Create whatever you would like to add (`touch foo.txt`, etc)
3. Run `deps` to ensure a symlink is created
