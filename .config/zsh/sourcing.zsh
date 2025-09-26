################################
# HIGH PRIO (should run first) #
################################

# install mise if needed
# https://github.com/jdx/mise?tab=readme-ov-file
if [ ! -f "$HOME/.local/bin/mise" ]; then
	echo "mise is not installed. installing now..."
	curl -s https://mise.run | sh
fi

# start mise
eval "$(~/.local/bin/mise activate zsh)"

##########
# PYTHON #
##########

# configure pyright
# export PYRIGHT_PYTHON_FORCE_VERSION='latest'
export PYRIGHT_PYTHON_FORCE_VERSION=$(mise current python)

##############
# JAVASCRIPT #
##############

# give node 4GB of memory
export NODE_OPTIONS="--max-old-space-size=4000"

# load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # this loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # this loads nvm bash_completion

# nvm auto version use
# credit: @elliotf
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
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
autoload -Uz compinit && compinit
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

# set up custom macos keymaps
hidutil property --set "$(cat $HOME/.config/macos/key_remaps.json)" >/dev/null 2>&1

###############################
# set up vim mode in terminal #
###############################

# https://github.com/jeffreytse/zsh-vi-mode
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
# when we do "vv", open in nvim instead of what's at $EDITOR
export ZVM_VI_EDITOR=nvim
# custom function to accept line and switch to insert mode
function my_accept_line() {
	zle accept-line
	zvm_enter_insert_mode
}
# set up custom keybinding after zsh-vi-mode initialization
function zvm_after_lazy_keybindings() {
	zvm_define_widget my_accept_line
	zvm_bindkey vicmd '^M' my_accept_line
}

###################
# command history #
###################

setopt HIST_IGNORE_ALL_DUPS   # remove all previous entries matching new command
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicate entries first when trimming history
setopt HIST_REDUCE_BLANKS     # remove extra blanks
setopt HIST_IGNORE_SPACE      # don't record commands that start with a space

#######
# tpm #
#######

# make sure tpm is cloned locally for tmux plugin management
# Ensure TPM is installed in the home directory
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	mkdir -p "$HOME/.tmux/plugins"
	git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
