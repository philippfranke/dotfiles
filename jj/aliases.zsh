# jj (Jujutsu) shell aliases, mirroring the git ones in git/aliases.zsh.
# Auto-sourced via the **/*.zsh glob in zsh/zshrc.symlink.

# Mirror of `gp='git push origin HEAD'`. jj pushes bookmarks rather than
# a current branch, so this pushes tracked bookmarks. To push current
# unbookmarked work, use: jj git push -c @-
alias jp='jj git push'

# Mirror of `gc='git commit'`.
alias jc='jj commit'
