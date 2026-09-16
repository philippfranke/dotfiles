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

# Launch Claude Code with secrets injected from 1Password.
#
# Put `NAME=op://<vault>/<item>/<field>` lines in ~/.config/op/claude.env
# (untracked, chmod 600 — template in 1password/claude.env.example; override
# the path with $CLAUDE_OP_ENV_FILE). `op run` resolves the references at
# launch and exposes the values only to the claude process, so no plaintext
# token ever lives in a dotfile or the shell env. Without op or the env file
# this is a transparent pass-through. Skipped inside an existing Claude session
# ($CLAUDECODE is set): the child already inherits the injected env, and a
# second `op run` would just trigger another unlock prompt.
claude() {
  local env_file="${CLAUDE_OP_ENV_FILE:-$HOME/.config/op/claude.env}"
  if (( $+commands[op] )) && [[ -r "$env_file" && -z "$CLAUDECODE" ]]; then
    # --no-masking: claude is a TUI and needs its stdout untouched.
    op run --env-file="$env_file" --no-masking -- claude "$@"
  else
    command claude "$@"
  fi
}
