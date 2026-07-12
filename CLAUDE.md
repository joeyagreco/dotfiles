## overview
macOS dotfiles repo. configs live in `.config/` and get symlinked to `~` via `make links` (runs `scripts/python/link_init.py`). dependencies are installed via `make deps` which handles brew, pip, go, cargo, and npm.

## repo structure
- `.config/` - main config hub (zsh, nvim, tmux, ghostty, git, starship, hammerspoon, mise, etc.)
- `deps/` - dependency lists (Brewfile, requirements.txt, cargo_deps.txt, go_deps.txt, npm_deps.txt)
- `scripts/bash/` - utility shell scripts (battery, cpu, memory, git helpers, tmux helpers)
- `scripts/python/` - setup scripts (link_init.py, deps_init.py)

## key tools
- **zsh** (`.config/zsh/`) - shell config with aliases, functions, variables
- **ghostty** (`.config/ghostty/`) - terminal emulator
- **tmux** (`.config/tmux/`) - terminal multiplexer
- **starship** (`.config/starship/`) - shell prompt
- **git** (`.config/git/`) - global gitconfig, gitignore, commit template
- **hammerspoon** (`.config/hammerspoon/`) - macOS automation
- **mise** (`.config/mise/`) - version manager (node, go, cargo, neovim)
- **macos** (`.config/macos/`) - macOS system settings and key remapping

## nvim
`.config/nvim`
- uses [lazy](https://lazy.folke.io/) for package management
- to see actual downloaded plugin code, navigate to `~/.local/share/nvim/lazy/`, which will have a directory for each plugin
    - when trying to understand or debug something relating to a plugin, you can search here to see the actual code being run
