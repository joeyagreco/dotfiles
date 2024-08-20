# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv rehash)"
# used as a constant in nvim
export PYTHON_PATH=$(pyenv which python)
# configure pyright
export PYRIGHT_PYTHON_FORCE_VERSION='latest'

# golang
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
export PATH="$GOROOT/bin:$PATH"
eval "$(goenv init -)"
eval "$(goenv rehash)"

# cargo
# set up cargo
export PATH="$HOME/.cargo/bin:$PATH"

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
