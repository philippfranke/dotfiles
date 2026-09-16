# GitHub client: `gh` (https://cli.github.com), configured in gh/config.yml
# (linked to ~/.config/gh/config.yml by script/bootstrap). Unlike the old `hub`
# it is not a git wrapper, so `git` stays plain git. Auth (hosts.yml) is
# machine-local and untracked: run `gh auth login` once per machine.

alias gp='git push origin HEAD'
alias gc='git commit'
