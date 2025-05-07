function f_cls() {
	# clear the terminal
	clear

	# clear tmux history if in tmux session
	if [ -n "$TMUX" ]; then
		tmux clear-history
	fi
}

function port() {
	lsof -i :"$1"
}

function f_venvup() {
	$PYTHON_COMMAND -m venv "$1"
	source "$1/bin/activate"
}

function f_venvdown() {
	if [ -z "$1" ]; then
		echo "Error: No virtual environment directory specified"
		return 1
	fi

	if [ ! -d "$1" ]; then
		echo "Error: Directory $1 does not exist"
		return 1
	fi

	if source "$1/bin/activate"; then
		deactivate
		rm -rf "$1"
	else
		echo "Failed to activate the virtual environment"
		return 1
	fi
}

# open up the given repo
function c() {
	cd $LOCAL_GIT_REPO_PATH || return
	if [[ -n $1 ]]; then
		cd "$1" || return
	fi
}

# set up a new tmux session for coding in the given repo
function f_setup() {
	c "$1" && four && tmux new-window "nvim"
}

# function to repeat commands
# e.g. `repeat 3 echo 'foo'` -> foo foo foo
function repeat {
	local count=$1
	shift
	for ((i = 1; i <= count; i++)); do
		"$@"
	done
}
