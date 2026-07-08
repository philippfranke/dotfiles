# op (1Password CLI) zsh completion. Lives in a completion.zsh so zshrc sources
# it in the final pass, after compinit (op's completion script calls compdef).
# Guarded so it's skipped where op is absent.
if (( $+commands[op] )); then
  eval "$(op completion zsh)"
fi
