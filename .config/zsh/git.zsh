# only set if not already set to avoid seeing an error like this:
#   > error: could not lock config file /foo/bar/.gitconfig: File exists
# when sourcing multiple tmux panes at once

function set_git_global_if_unset() {
  local key="$1"
  local value="$2"
  [ "$(git config --global "$key")" != "$value" ] && git config --global "$key" "$value"
}

# set a global gitignore file
# to check that this was set properly, run this: git config --get core.excludesfile
set_git_global_if_unset core.excludesfile "$HOME/.config/git/gitignore_global"

# set a global gitconfig file
# to check that this was set properly, run this: git config --get include.path
set_git_global_if_unset include.path     "$HOME/.config/git/gitconfig_global"
