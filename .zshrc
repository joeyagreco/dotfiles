#############
# VARIABLES #
#############
# THESE SHOULD BE OVERRITTEN IN .zshrc.local
LOCAL_GIT_REPO_PATH="NOT_SET"
# THESE ARE GLOBAL
LOCAL_AFFIX=".local"
PYTHON_VERSION="python3.10"
ZSHRC_FILE_PATH="$HOME/.zshrc"
ALACRITTY_FILE_PATH="$HOME/.alacritty.yml"
TMUX_FILE_PATH="$HOME/.tmux.conf"
STARSHIP_FILE_PATH="$HOME/.starship.toml"
VIM_FILE_PATH="$HOME/.vimrc"
SCRIPTS_PATH="$HOME/.scripts"

############
# SOURCING #
############
# fuzzy find
eval "$(fzf --zsh)"
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# USE TAB TO COMPLETE AUTOSUGGESTION
bindkey "^I" autosuggest-accept

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
alias ic="ping 8.8.8.8"
alias home='cd ~'
alias cls='clear'
alias clearpanes="tmux list-panes -F '#{pane_id}' | xargs -I {} tmux send-keys -t {} 'clearall' C-m"
alias speed='clearall && speedtest-cli --secure --no-upload'
# PYTHON
alias py="$PYTHON_VERSION"
alias pip="$PYTHON_VERSION -m pip"
# open up a project in pypi
alias pp='function _pp(){ open "https://pypi.org/project/$1/"; }; _pp'
# check name availability on pypi
alias pypi='$PYTHON_VERSION $SCRIPTS_PATH/python/pypi_check.py'
# use venv
alias venv='$PYTHON_VERSION -m venv'
alias venvdown='deactivate'
# GIT
alias gitco='git checkout'
alias gitf='git fetch --all'
alias emptycommit='git commit --allow-empty -m '\''empty commit'\'
alias gcnv="git commit --no-verify"

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


function venvup() {
  source "$1/bin/activate"
}


function c() {
  cd $LOCAL_GIT_REPO_PATH
  if [[ -n $1 ]]; then
    cd "$1" 
  fi
}


# download a youtube link to mp3
function mp3() {
  unsetopt glob
  $PYTHON_VERSION $SCRIPTS_PATH/python/mp_download.py "mp3" "$1"
  setopt glob
}

# download a youtube link to mp4
function mp4() {
  unsetopt glob
  $PYTHON_VERSION $SCRIPTS_PATH/python/mp_download.py "mp4" "$1"
  setopt glob
}

#########################
# ACTIVATE LOCAL CONFIG #
#########################

# THIS MUST STAY AT THE BOTTOM OF THE FILE
if [ -f $ZSHRC_FILE_PATH$LOCAL_AFFIX ]; then
    source $ZSHRC_FILE_PATH$LOCAL_AFFIX
else;
    echo "NO .zshrc.local FILE FOUND!"
fi
    
