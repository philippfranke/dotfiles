export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"

# Homebrew's zsh 5.9.1 bottle bakes in an fpath that points at a
# non-existent versioned functions dir (.../zsh/5.9/functions rather than
# 5.9.1), so core autoloaded functions like `colors` and `compinit` fail
# with "function definition file not found". Add the real (unversioned)
# Homebrew functions dir to fpath when present (Apple Silicon or Intel).
for _fndir in /opt/homebrew/share/zsh/functions /usr/local/share/zsh/functions; do
  [[ -d "$_fndir" ]] && fpath=("$_fndir" $fpath)
done
unset _fndir
