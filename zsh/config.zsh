# Detect SSH connection and modify prompt accordingly
# SSH connections include the machine name in the prompt
if [[ -n $SSH_CONNECTION ]]; then
  export PS1='%m:%3~ %# '
else
  export PS1='%3~ %# '
fi

# Load functions from the $ZSH/functions directory
fpath=($ZSH/functions $fpath)
autoload -U $ZSH/functions/*(:t)

# Colorize 'ls' command output
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

# Set up command history
HISTFILE=~/.zsh_history
export HISTFILE=$HISTFILE
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HISTIGNORESPACE

# Configure job control behavior
setopt NO_HUP
setopt NO_BG_NICE
setopt IGNORE_EOF

# Suppress beeps on tab completion
setopt NO_LIST_BEEP

# Configure function behavior
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS

# Configure prompt behavior
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt COMPLETE_ALIASES
