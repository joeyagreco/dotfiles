#############
# VARIABLES #
#############
# THESE SHOULD BE OVERWRITTEN IN .zshrc.local
export LOCAL_GIT_REPO_PATH="NOT_SET"
# THESE ARE GLOBAL
export LOCAL_AFFIX=".local"
export PYTHON_VERSION="python3.10"
export PYTHON_PATH=$(which $PYTHON_VERSION)
export ZSHRC_FILE_PATH="$HOME/.zshrc"
export ZSHRC_LOCAL_FILE_PATH=$ZSHRC_FILE_PATH$LOCAL_AFFIX
export ALACRITTY_FILE_PATH="$HOME/.alacritty.yml"
export TMUX_FILE_PATH="$HOME/.tmux.conf"
export STARSHIP_FILE_PATH="$HOME/.starship.toml"
export VIM_FILE_PATH="$HOME/.vimrc"
export SCRIPTS_PATH="$HOME/scripts"
export PYTHON_SCRIPTS_PATH="$SCRIPTS_PATH/python"
export DOWNLOADS_PATH="$HOME/Downloads"
export PYENV_ROOT="$HOME/.pyenv"

############
# SOURCING #
############

# set up pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# fuzzy find
eval "$(fzf --zsh)"
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# set up starship
# https://starship.rs/
export STARSHIP_CONFIG=$STARSHIP_FILE_PATH
eval "$(starship init zsh)"

# Case-insensitive (all), completion (comp) and listing (list).
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Case-insensitive for command execution.
setopt NO_CASE_GLOB
setopt EXTENDED_GLOB

# enable tab completion
autoload -U compinit promptinit

###########
# ALIASES #
###########

# DOTFILES
alias aa="vim $ALACRITTY_FILE_PATH"
alias zz="vim $ZSHRC_FILE_PATH"
alias zzl="vim $ZSHRC_FILE_PATH$LOCAL_AFFIX"
alias applyz="source $ZSHRC_FILE_PATH"
alias tt="vim $TMUX_FILE_PATH"
alias applyt="tmux source-file $TMUX_FILE_PATH"
alias vv="vim $VIM_FILE_PATH"
alias ss="vim $STARSHIP_FILE_PATH"
# GENERAL QOL
# install any dependencies
alias deps="install_deps"
alias docker-compose="docker compose"
alias ic="ping 8.8.8.8"
alias home='cd ~'
# screenshot and save to downloads folder
alias sss="screencapture -x $DOWNLOADS_PATH/terminal-screenshot-$(date '+%Y%m%d%H%M%S').png"
alias cls='clear'
alias clearpanes="clear_all_panes && all_panes 'clearall'"
alias speed='clearall && speedtest-cli --secure --no-upload'
alias foo='echo "foo\nbar\nbaz\nqux\nquux\ncorge\ngrault\ngarply\nwaldo\nfred\nplugh\nxyxxy\nthud"'
alias make='gmake'
# get shortened URL for given url (surl https://my/url) or for whatever url is copied to clipboard.
# copies shortened URL to clipboard automatically
# s(hort)url
alias surl="$PYTHON_VERSION $PYTHON_SCRIPTS_PATH/surl.py "
# vimc(heat)s(heet)
alias vimcs='open "https://cheatography.com/marconlsantos/cheat-sheets/neovim/"'
# PYTHON
alias py="$PYTHON_VERSION"
alias pip="$PYTHON_VERSION -m pip"
# open up a project in pypi
# o(pen)pypi
alias opypi='function _pp(){ open "https://pypi.org/project/$1/"; }; _pp'
# check name availability on pypi
# a(vailability)pypi
alias apypi="$PYTHON_VERSION $PYTHON_SCRIPTS_PATH/pypi_check.py"
# use venv
alias venv="$PYTHON_VERSION -m venv"
alias venvup='f_venvup'
alias venvdown='f_venvdown'
alias venvlist="$PYTHON_VERSION $PYTHON_SCRIPTS_PATH/venv_check.py"
# GIT
alias gitco='git checkout'
alias gitf='git fetch --all'
alias emptycommit='git commit --allow-empty -m '\''empty commit'\'' && git push'
alias gcnv="git commit --no-verify"
# list the n most recent git branches
alias recentbranch="git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)' | head -n "
# push to branch that only exists locally and set upstream
alias gpu='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'

#############
# FUNCTIONS #
#############

function clearall() {
  # clear the terminal
  clear

  # clear tmux history if in tmux session
  if [ -n "$TMUX" ]; then
    tmux clear-history
  fi
}


function port() {
    lsof -i :$1
}


function f_venvup() {
  venv $1
  source "$1/bin/activate"
}

function f_venvdown() {
  deactivate $1
  rm -rf $1
}

# open up the given repo
function c() {
  cd $LOCAL_GIT_REPO_PATH
  if [[ -n $1 ]]; then
    cd "$1" 
  fi
}


# download a youtube link to mp3
function mp3() {
  unsetopt glob
  $PYTHON_VERSION $PYTHON_SCRIPTS_PATH/mp_download.py "mp3" "$1"
  setopt glob
}

# download a youtube link to mp4
function mp4() {
  unsetopt glob
  $PYTHON_VERSION $PYTHON_SCRIPTS_PATH/mp_download.py "mp4" "$1"
  setopt glob
}

function install_deps() {
  $PYTHON_VERSION $PYTHON_SCRIPTS_PATH/link_init.py
  pip install --upgrade pip
  pip install -r $HOME/requirements.txt
  npm install -g --prefix $HOME
  brew update
  brew bundle --file=$HOME/Brewfile
  brew cleanup
  # make sure packer is installed for nvim
  # TODO: this fails most of the time bc already cloned
  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

}


# clears all tmux panes
function clear_all_panes() {
  for pane in $(tmux list-panes -F '#{pane_id}'); do tmux send-keys -t $pane C-u; done
}

# executes the given command in all tmux panes
function all_panes() {
  if [ -z "$1" ]; then
   echo "Usage: all_panes <command>"
   return 1
   fi
  tmux list-panes -F '#{pane_id}' | xargs -I {} tmux send-keys -t {} "$1" C-m
}


#########################
# ACTIVATE LOCAL CONFIG #
#########################

# THIS MUST STAY AT THE BOTTOM OF THE FILE
if [ -f $ZSHRC_LOCAL_FILE_PATH ]; then
    source $ZSHRC_LOCAL_FILE_PATH
else;
    echo "NO .zshrc.local FILE FOUND!"
fi
    
