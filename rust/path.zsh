# Rust/cargo PATH. Loaded in the first (path) pass by zsh/zshrc.symlink.
#
# rustup already prepends ~/.cargo/bin via ~/.zshenv; declared here too so the
# dotfiles are self-contained. zsh/path.zsh's `typeset -U` dedupes the overlap.
path=("$HOME/.cargo/bin" $path)
