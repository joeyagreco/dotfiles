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

alias vi="vim"
alias ic="ping 8.8.8.8"
alias home='cd ~'
alias ls='eza'
alias cd='z'
alias nukerepo="$BASH_SCRIPTS_PATH/nuke_repo.sh"
# open up notes in nvim in a new tmux window
alias nn="tmux new-window -c $NOTES_PATH nvim"
# screenshot and save to downloads folder
alias ss="screencapture -x $DOWNLOADS_PATH/terminal-screenshot-$(date '+%Y%m%d%H%M%S').png"
alias cls="f_cls"
alias foo='echo "foo\nbar\nbaz\nqux\nquux\ncorge\ngrault\ngarply\nwaldo\nfred\nplugh\nxyxxy\nthud"'
alias make='gmake'
# get path of last downloaded file in clipboard and in env var
alias lastdownload=". $BASH_SCRIPTS_PATH/last_download.sh"

##########
# PYTHON #
##########

alias py="$PYTHON_COMMAND"
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
# list the 10 most recent git branches
# [g]it[r]ecent[b]ranches
alias grb="git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)' | head -n 10"
# push to branch that only exists locally and set upstream
# [g]it[p]ush[u]pstream
alias gpu='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
# list commits on current branch that have not been pushed to remote
# [g]it[c]ommits[r]emote
alias gcr='git log @{u}..HEAD'
# [g]it[c]ommit[p]ush
alias gcp='git commit -am "quick commit" && git push'
