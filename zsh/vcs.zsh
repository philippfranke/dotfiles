# Shared VCS detection helpers, sourced via the **/*.zsh glob in
# zsh/zshrc.symlink. Used by zsh/prompt.zsh and available to aliases
# and scripts.
#
# Note: jj repos are usually *colocated* with git (both .jj and .git
# exist), so these are not mutually exclusive. Always check jj first.

# True if the current directory is inside a jj repo.
# --ignore-working-copy keeps this read-only (no snapshot / new op).
in_jj_repo() {
  (( $+commands[jj] )) && jj --ignore-working-copy root &> /dev/null
}

# True if the current directory is inside a git working tree.
in_git_repo() {
  git rev-parse --is-inside-work-tree &> /dev/null
}

# Echo the preferred VCS for the current directory: "jj", "git", or
# nothing. jj wins over git for colocated repos.
vcs() {
  if in_jj_repo; then
    echo jj
  elif in_git_repo; then
    echo git
  fi
}
