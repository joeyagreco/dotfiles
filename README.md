# terminal

# Setting up a New Computer

1. Clone this Git repo
2. Create a symlink for each dir/file from your root dir
```sh
# from the root dir
# run something like this for each dir/file
ln -s /path/to/this/repo/locally/.vimrc .vimrc
```
3. Create a `.zshrc.local` file in the root dir to keep local config