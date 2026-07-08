# Docker convenience aliases. Guarded so they're a no-op where docker is absent.
#
# NOTE: ~/.docker/config.json is intentionally NOT tracked by these dotfiles —
# it contains an "auths" block with registry credentials. Keep it local.
if (( $+commands[docker] )); then
  alias d='docker'
  alias dc='docker compose'
  alias dps='docker ps'
  alias dimg='docker images'
fi
