alias vim="nvim"
alias vi="nvim"
#alias tmux="tmux attach || tmux"
# macOS Tailscale app CLI — guarded so non-macOS shells skip the broken alias
_tailscale_bin="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
[[ -x "$_tailscale_bin" ]] && alias tailscale="$_tailscale_bin"
unset _tailscale_bin
