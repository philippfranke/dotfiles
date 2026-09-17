# Homebrew PATH/env. Loaded in the first (path) pass by zsh/zshrc.symlink and,
# via ~/.zshenv, in every non-interactive zsh too.
#
# Apple's /etc/zprofile only runs path_helper; Homebrew itself is put on PATH by
# `brew shellenv`, which also exports HOMEBREW_PREFIX/CELLAR/REPOSITORY and
# prepends the brew MANPATH/INFOPATH. It lives here rather than in ~/.zprofile so
# non-login shells (nvim `:!`, tmux server, GUI-launched apps) see brew as well.
# Guarded on the binary so the file is a no-op on machines without Homebrew.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [[ -x "$_brew" ]]; then
    eval "$("$_brew" shellenv)"
    break
  fi
done
unset _brew
