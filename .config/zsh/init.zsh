source "$ZSH_PATH/variables.zsh"
source "$ZSH_PATH/sourcing.zsh"
source "$ZSH_PATH/aliases.zsh"
source "$ZSH_PATH/functions.zsh"
source "$ZSH_PATH/git.zsh"
# MUST STAY AT THE BOTTOM
source "$HOME/.zshrc$LOCAL_FIX"

# CHECK FOR REQUIRED ENV VARS
# THESE MUST MANUALLY BE SET ON EACH MACHINE THAT USES THIS CONFIG
# (typically just set in ~/.zshrc.local)
required_vars=("LOCAL_GIT_REPO_PATH" "GITHUB_PREFIX" "OPENAI_API_KEY")

for var in $required_vars; do
    if [[ -z "${(P)var}" ]]; then
        echo "$var not set"
    fi
done
