# link ~/.ssh/config to the repo's config (skip if something's already there)
if [ ! -e "$HOME/.ssh/config" ] && [ ! -L "$HOME/.ssh/config" ] && [ -e "$HOME/.config/ssh/config" ]; then
  ln -s "$HOME/.config/ssh/config" "$HOME/.ssh/config"
fi

# warm the github ssh master in the background if it's down (e.g. after reboot)
if ! ssh -O check git@github.com >/dev/null 2>&1; then
  ssh -T git@github.com >/dev/null 2>&1 &!
fi
