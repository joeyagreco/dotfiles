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

function f_setup() {
	c "$1" && four && tmux new-window "nvim"
}

function install_deps() {
	# create symlinks if needed
	# THIS SHOULD BE FIRST
	$PYTHON_COMMAND "$PYTHON_SCRIPTS_PATH/link_init.py"

	# setup for various languages
	f_setup_python
	f_setup_golang
	f_setup_cargo

	# install python package deps
	pip install --upgrade --quiet pip
	pip install --quiet -r "$DEPS_DIR_PATH/requirements.txt"

	# install brew deps
	brew update -q
	brew bundle -q --file="$DEPS_DIR_PATH/Brewfile"
	# commenting this out as it errors without sudo permissions
	# uncommenting for now as im not seeing errors listed in above comment
	brew cleanup -q

	# install go, cargo, and npm deps
	$PYTHON_COMMAND "$PYTHON_SCRIPTS_PATH/deps_init.py"
}

function f_setup_python() {
	echo "setting up python"
	# set up pyenv
	# this installs if not exists
	pyenv install -s $(cat .python-version)
	echo "finished setting up python"
}

function f_setup_golang() {
	# NOTE: run `which go` and if you see something not set up by goenv
	# run something like this `sudo mv {go location} {go location}_backup`
	# then run `which go` again to ensure it is now set by goenv
	echo "setting up golang..."
	# set up goenv
	# this installs if not exists
	goenv install -s $(cat .go-version)
	echo "finished setting up golang"
}

function f_setup_cargo() {
	echo "setting up cargo..."
	# make sure cargo is installed
	if
		! command -v cargo &>/dev/null
	then
		echo "cargo could not be found, installing..."
		curl https://sh.rustup.rs -sSf | sh
	fi
	echo "finished setting up cargo"
}

function f_opypi() {
	open "https://pypi.org/project/$1/"
}
