# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for setting up a new macOS development environment. The repository contains configuration files, utility scripts, and setup automation.

## Architecture

- **Root level**: Configuration files (dotfiles) that get symlinked to `$HOME`
- **scripts/**: Utility scripts organized by language
  - **python/**: Setup and automation scripts
  - **bash/**: System utility scripts  
- **deps/**: Dependency files for different package managers

## Required Environment Variables

Before running any commands, ensure these environment variables are set in `~/.zshrc.local`:

```bash
export LOCAL_GIT_REPO_PATH="/path/to/git/repos/on/this/computer"
export GITHUB_PREFIX="my_github_profile_or_org"
```

## Common Commands

### Initial Setup
```bash
# Create symlinks from dotfiles to home directory
make links

# Install all dependencies (requires environment variables to be set)
source ~/.zshrc.local && source ~/zsh/init.zsh && make deps
```

### Code Quality
```bash
# Run ruff linter on Python files
ruff check scripts/python/

# Format Python code with ruff
ruff format scripts/python/
```

## Key Scripts

- **link_init.py**: Creates symlinks from repository dotfiles to `$HOME`, with interactive prompts
- **deps_init.py**: Installs dependencies from text files using various package managers (npm, go, cargo)
- **ai_git_commit_msg.py**: Generates AI-powered git commit messages using OpenAI
- **nuke_repo.sh**: Safely deletes and re-clones a repository

## Dependencies Structure

The `deps/` directory contains:
- `Brewfile`: Homebrew packages
- `requirements.txt`: Python packages  
- `npm_deps.txt`: Global npm packages
- `go_deps.txt`: Go packages
- `cargo_deps.txt`: Rust packages

## Python Environment

- Uses `uv` for Python package management
- Configured with ruff for linting (imports and unused import removal)
- Python scripts expect system-wide installation of dependencies