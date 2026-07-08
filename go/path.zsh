# Go PATH/env. Loaded in the first (path) pass by zsh/zshrc.symlink.
#
# GOPATH under ~/.go so `go install` and vim-go's tools (vim/vimrc.symlink
# g:go_bin_path) share one bin dir. ~/go/bin kept as a fallback so tools
# installed there before this move stay on PATH until reinstalled.
export GOPATH="$HOME/.go"
path=("$HOME/.go/bin" "$HOME/go/bin" $path)
