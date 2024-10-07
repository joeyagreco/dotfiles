############
# DOTFILES #
############

alias zzl="nvim $HOME/.zshrc$LOCAL_FIX"
alias applyz="source $ZSHRC_FILE_PATH"
alias applyt="tmux source-file $TMUX_FILE_PATH"

########
# TMUX #
########

# attach to a session by name
alias tma="tmux attach -t"
# attach to the last session
alias tmaa="tmux attach"
# detach from the current session
alias tmd="tmux detach"
# kill a session by name
alias tmk="tmux kill-session -t"
# kill all sessions except the current
alias tmkk="tmux kill-session -a"
# list all tmux sessions
alias tml="tmux list-sessions -F '#{session_name}'"
# create a new named tmux session
alias tmn="tmux new-session -A -s"
# split the current pane into 4 equal panes
alias four='tmux split-window -h \; split-window -v \; select-pane -L \; split-window -v'
# set up a new tmux session for coding in the given repo
alias setup='f_setup'

##########
# DOCKER #
##########

alias docker-compose="docker compose"
# list all docker info in a nice way
alias dps="docker ps --format '{{.ID}} {{.Image}} {{.Status}}'"
# stop all running containers
alias dstop='docker stop $(docker ps -q)'

###############
# GENERAL QOL #
###############

# install any dependencies
alias deps="install_deps"
alias vi="vim"
alias ic="ping 8.8.8.8"
alias home='cd ~'
alias ls='eza'
alias cd='z'
alias nukerepo="$BASH_SCRIPTS_PATH/nuke_repo.sh"
# create a new note
alias note="$PYTHON_COMMAND $PYTHON_SCRIPTS_PATH/notes.py"
# open up notes in nvim in a new tmux window
alias nn="tmux new-window -c $NOTES_PATH nvim"
# screenshot and save to downloads folder
alias ss="screencapture -x $DOWNLOADS_PATH/terminal-screenshot-$(date '+%Y%m%d%H%M%S').png"
alias cls="f_cls"
alias foo='echo "foo\nbar\nbaz\nqux\nquux\ncorge\ngrault\ngarply\nwaldo\nfred\nplugh\nxyxxy\nthud"'
alias make='gmake'
alias slack='open -a "Slack"'
# get path of last downloaded file in clipboard and in env var
alias lastdownload=". $BASH_SCRIPTS_PATH/last_download.sh"

##########
# PYTHON #
##########

alias py="$PYTHON_COMMAND"
# open up a project in pypi
# o(pen)pypi
alias opypi="f_opypi"
# check name availability on pypi
# a(vailability)pypi
alias apypi=$PYTHON_COMMAND "$PYTHON_SCRIPTS_PATH/pypi_check.py"
# use venv
alias venv=$PYTHON_COMMAND "-m venv"
alias venvup='f_venvup'
alias venvdown='f_venvdown'

#######
# GIT #
#######

alias gitco='git checkout'
alias gitf='git fetch --all'
alias emptycommit='git commit --allow-empty --no-verify -m '\''empty commit'\'' && git push'
# [g]it[c]ommit[n]o[v]erify
alias gcnv="git commit --no-verify"
# list the n most recent git branches
# [g]it[r]ecent[b]ranches
alias grb="git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)' | head -n "
# push to branch that only exists locally and set upstream
# [g]it[p]ush[u]pstream
alias gpu='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
# list commits on current branch that have not been pushed to remote
# [g]it[c]ommits[r]emote
alias gcr='git log @{u}..HEAD'
