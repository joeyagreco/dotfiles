################################
# HIGH PRIO (should run first) #
################################


# NOTE: @joeyagreco - ideally, this lives in our setup-macos script, but we need this to run on startup :/
# first, set up custom keymaps
hidutil property --set "$(cat $HOME/.config/macos/key_remaps.json)" >/dev/null 2>&1

# install mise if needed
# https://github.com/jdx/mise?tab=readme-ov-file
if [ ! -f "$HOME/.local/bin/mise" ]; then
	echo "mise is not installed. installing now..."
	curl -s https://mise.run | sh
fi

# start mise
# eval "$(~/.local/bin/mise activate zsh)"

# NOTE: @joeyagreco - im doing the below instead of the above to speed up sourcing times

# use mise shims instead of activation for faster startup
export PATH="$HOME/.local/share/mise/shims:$PATH"

##########
# PYTHON #
##########

# configure pyright
# export PYRIGHT_PYTHON_FORCE_VERSION='latest'
# NOTE: commented out since it is slow on sourcing. unsure if needed.
# export PYRIGHT_PYTHON_FORCE_VERSION=$(mise current python)

##############
# JAVASCRIPT #
##############

# give node 4GB of memory
export NODE_OPTIONS="--max-old-space-size=4000"

# NOTE: we do these lazy loadings to save ~500ms every time this is sourced

# lazy load nvm
export NVM_DIR="$HOME/.nvm"

# placeholder nvm function that loads the real nvm on first use
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

# lazy load node
node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  node "$@"
}

# lazy load npm
npm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  npm "$@"
}

# lazy load npx
npx() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  npx "$@"
}

# nvm auto version use
# credit: @elliotf
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    # ensure nvm is loaded before using it
    if ! command -v nvm &> /dev/null || [[ "$(type -w nvm)" == "nvm: function" ]]; then
      unset -f nvm node npm npx 2>/dev/null
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
    nvm use
  fi
}
add-zsh-hook chpwd load-nvmrc

##########
# GOLANG #
##########

export GOPROXY=https://proxy.golang.org

#########
# CARGO #
#########

# set up cargo
export PATH="$HOME/.cargo/bin:$PATH"

###########
# GENERAL #
###########

# apply local alacritty settings
"$HOME/.config/alacritty/alacritty.local.sh"

# set up brew
if [[ -z "$HOMEBREW_PREFIX" ]]; then
	export HOMEBREW_PREFIX="$(brew --prefix)"
fi
export PATH="$HOMEBREW_PREFIX/bin:$PATH"

# set up syntax highlighting
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# set up starship
# https://starship.rs/
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
# NOTE: got this from here: https://github.com/starship/starship/issues/3418#issuecomment-1711630970
# NOTE: this is to due to seeing this issue: https://github.com/starship/starship/issues/5522
# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
type starship_zle-keymap-select >/dev/null ||
	{
		eval "$(starship init zsh)"
	}

# case-insensitive (all), completion (comp) and listing (list).
autoload -Uz compinit -C && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# case-insensitive for command execution.
setopt NO_CASE_GLOB
setopt EXTENDED_GLOB

# no duplicates in terminal command history
setopt HIST_IGNORE_DUPS

# history scrolling based on first word in input
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search   # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# fzf history search with ctrl+r
fzf-history-widget() {
  local selected
  selected=$(fc -rl 1 | fzf --tac --no-sort --exact --query="$LBUFFER" | awk '{$1=""; print substr($0,2)}')
  if [ -n "$selected" ]; then
    LBUFFER="$selected"
  fi
  zle reset-prompt
}
zle -N fzf-history-widget
bindkey "^R" fzf-history-widget

###############################
# set up vim mode in terminal #
###############################

# NOTE: @joeyagreco - disabling for now as not sure i need/want this

# # https://github.com/jeffreytse/zsh-vi-mode
# source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
# # when we do "vv", open in nvim instead of what's at $EDITOR
# export ZVM_VI_EDITOR=nvim
# # custom function to accept line and switch to insert mode
# function my_accept_line() {
# 	zle accept-line
# 	zvm_enter_insert_mode
# }
# # set up custom keybinding after zsh-vi-mode initialization
# function zvm_after_lazy_keybindings() {
# 	zvm_define_widget my_accept_line
# 	zvm_bindkey vicmd '^M' my_accept_line
# }

# needed for:
# - claude code
export PATH="$HOME/.local/bin:$PATH"

###################
# command history #
###################

setopt HIST_IGNORE_ALL_DUPS   # remove all previous entries matching new command
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicate entries first when trimming history
setopt HIST_REDUCE_BLANKS     # remove extra blanks
unsetopt HIST_IGNORE_SPACE    # record commands that start with a space

#######
# tpm #
#######

# make sure tpm is cloned locally for tmux plugin management
# Ensure TPM is installed in the home directory
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	mkdir -p "$HOME/.tmux/plugins"
	git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
