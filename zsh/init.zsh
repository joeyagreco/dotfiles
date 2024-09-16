source "$ZSH_PATH/variables.zsh"
source "$ZSH_PATH/sourcing.zsh"
source "$ZSH_PATH/aliases.zsh"
source "$ZSH_PATH/functions.zsh"
# MUST STAY AT THE BOTTOM
source "$HOME/.zshrc$LOCAL_FIX"

# CHECK FOR REQUIRED ENV VARS
if [[ -z "$LOCAL_GIT_REPO_PATH" ]]; then
	echo "LOCAL_GIT_REPO_PATH not set"
fi

if [[ -z "$GITHUB_PREFIX" ]]; then
	echo "GITHUB_PREFIX not set"
fi
