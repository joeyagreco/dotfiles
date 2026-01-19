############
# DOTFILES #
############

alias zzl='nvim $HOME/.zshrc$LOCAL_FIX'
alias applyz='source $HOME/.zshrc'
alias applyt='tmux source-file $HOME/.config/tmux/tmux.conf'

########
# TMUX #
########

# attach to a session by name
alias tma='tmux attach -t'
# attach to the last session
alias tmaa='tmux attach'
# detach from the current session
alias tmd='tmux detach'
# kill a session by name
alias tmk='tmux kill-session -t'
# list all tmux sessions
alias tml='tmux list-sessions -F "#{session_name}"'
# create a new named tmux session
alias tmn='tmux new-session -A -s'
# split the current pane into 3 panes (2 vertical stack on the left and 1 on the right)
alias three='tmux split-window -h \; select-pane -L \; split-window -v'
# split the current pane into 4 equal panes
alias four='tmux split-window -h \; split-window -v \; select-pane -L \; split-window -v'
# set up a new tmux session for coding in the given repo
alias setup='f_setup'

##########
# DOCKER #
##########

alias docker-compose='docker compose'
# list all docker info in a nice way
alias dps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}"'
# stop all running containers
alias dstop='docker stop $(docker ps -q)'

###############
# GENERAL QOL #
###############

alias vi='vim'
alias cc='claude'
alias ic='ping 8.8.8.8'
alias home='cd ~'
alias ls='eza'
alias nukerepo='$BASH_SCRIPTS_PATH/nuke_repo.sh'
# open up notes in nvim in a new tmux window
alias nn='tmux new-window -c $NOTES_PATH nvim'
# screenshot and save to downloads folder
alias ss='screencapture -x $DOWNLOADS_PATH/terminal-screenshot-$(date "+%Y%m%d%H%M%S").png'
alias cls='f_cls'
alias foo='echo "foo\nbar\nbaz\nqux\nquux\ncorge\ngrault\ngarply\nwaldo\nfred\nplugh\nxyxxy\nthud"'
alias make='gmake'
# get path of last downloaded file in clipboard and in env var
alias lastdownload='. $BASH_SCRIPTS_PATH/last_download.sh'
alias info='fastfetch'
alias speed='networkquality'
# create a pr with github
alias pr='$BASH_SCRIPTS_PATH/pr.sh'
# create a pr with github and use claude to set the description and title of the pr
alias prd='gh pr create --fill --draft && printf "\nsetting pr title and description with claude...\n\n" && claude "/pr-description-and-title" --print'
alias prchecks='$BASH_SCRIPTS_PATH/watch-github-pr-ci-status.sh'
alias foo='foo'

##########
# PYTHON #
##########

alias py='$PYTHON_COMMAND'
# use venv
alias venv='$PYTHON_COMMAND -m venv'
alias venvup='f_venvup'
alias venvdown='f_venvdown'
