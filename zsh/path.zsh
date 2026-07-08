# Base PATH + fpath setup. Tool-specific PATH entries live in their own topic
# files (go/path.zsh, rust/path.zsh, …), which zsh/zshrc.symlink also loads in
# the first (path) pass. `typeset -U` dedupes the arrays so those topic files can
# prepend freely without stacking duplicate entries.
typeset -U path PATH fpath

path=("$HOME/.local/bin" $path)

# Homebrew's zsh 5.9.1 bottle bakes in an fpath that points at a
# non-existent versioned functions dir (.../zsh/5.9/functions rather than
# 5.9.1), so core autoloaded functions like `colors` and `compinit` fail
# with "function definition file not found". Add the real (unversioned)
# Homebrew functions dir to fpath when present (Apple Silicon or Intel).
for _fndir in /opt/homebrew/share/zsh/functions /usr/local/share/zsh/functions; do
  [[ -d "$_fndir" ]] && fpath=("$_fndir" $fpath)
done
unset _fndir
