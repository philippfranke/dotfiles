# detect SSH connection
if [[ -n $SSH_CONNECTION ]]; then
  export PS1='%m:%3~ %# '
else
  export PS1='%3~ %# '
fi

# load functions
fpath=($ZSH/functions $fpath)
autoload -U $ZSH/functions/*(:t)

# colorize ls
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

# history
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

# job control
setopt NO_HUP
setopt NO_BG_NICE
setopt IGNORE_EOF

# noise
setopt NO_LIST_BEEP

# function
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS

# prompt
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt COMPLETE_ALIASES
