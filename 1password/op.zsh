# 1Password CLI (op) shell integration. Guarded so it's a no-op without op.
#
# `op plugin init <cli>` writes biometric-unlock shims to ~/.config/op/plugins.sh
# (machine-local, untracked). Source it if present. Run `op plugin init gh` etc.
# to populate it on a new machine.
if (( $+commands[op] )); then
  if [[ -f "$HOME/.config/op/plugins.sh" ]]; then
    source "$HOME/.config/op/plugins.sh"
  fi
fi
