# terminal

# Setting up a New Computer

1. Clone this repo
2. Create a symlink for each dir/file that is in the git repo from here

```sh
# from the root dir
# run something like this for each dir/file
ln -s /path/to/git/repo/.foo .foo
```

3. Create a `.zshrc.local` file in the root dir to keep local config
4. Add this to `.zshrc.local` file:

```sh
export LOCAL_GIT_REPO_PATH="/path/to/git/repos/on/this/computer"
```

5. Run `applyz && applyz`
6. Install dependencies `deps`
7. Install `Hack Nerd Fond` from [this site](https://www.nerdfonts.com/font-downloads)

# Adding new things

1. Go to where the git repo is cloned
2. Create whatever you would like to add (`touch foo.txt`, etc)
3. Navigate to the root (home) directory of your computer
4. Create a symlink for the new item from here

```sh
# from the root dir
# run something like this for your new dir/file
ln -s /path/to/git/repo/foo.txt foo.txt
```
