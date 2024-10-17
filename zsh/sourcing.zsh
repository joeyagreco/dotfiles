##########
# PYTHON #
##########

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv rehash)"
# used as a constant in nvim
export PYTHON_PATH=$(pyenv which python)
# configure pyright
export PYRIGHT_PYTHON_FORCE_VERSION='latest'

##############
# JAVASCRIPT #
##############

# https://stackoverflow.com/questions/16904658/node-version-manager-install-nvm-command-not-found
source ~/.nvm/nvm.sh
# ensure we are using the right node version
nvm alias default $(cat .node-version) >/dev/null
# give node 2GB of memory
export NODE_OPTIONS="--max-old-space-size=2000"

##########
# GOLANG #
##########

export GOENV_ROOT="$HOME/.goenv"
export PATH="$HOME/go/bin:$PATH"
export PATH="$GOENV_ROOT/bin:$PATH"
export PATH="$GOROOT/bin:$PATH"
eval "$(goenv init -)"
eval "$(goenv rehash)"

#########
# CARGO #
#########

# set up cargo
export PATH="$HOME/.cargo/bin:$PATH"

########
# RUBY #
########

# https://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac
source "$HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh"
source "$HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh"

###########
# GENERAL #
###########

# set up brew
export PATH="/opt/homebrew/bin:$PATH"

# set up syntax highlighting
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# set up zoxide
eval "$(zoxide init zsh)"

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

# no duplicates in terminal command history
setopt HIST_IGNORE_DUPS

# history scrolling based on first word in input
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search   # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# set up custom macos keymaps
hidutil property --set "$(cat $HOME/.macos_key_remaps.json)" >/dev/null 2>&1

# make sure tpm is cloned locally for tmux plugin management
# Ensure TPM is installed in the home directory
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	mkdir -p "$HOME/.tmux/plugins"
	git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
