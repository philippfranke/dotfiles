# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

# load color shortcuts
autoload colors && colors

# Determine the path for the git command.
if (( $+commands[git] )); then
  git="${commands[git]}"
else
  git="/usr/bin/git"
fi

# Function to get the current git branch
git_branch() {
  echo "$($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})"
}

# Function to determine if the current git directory is dirty (changes are uncommitted)
git_dirty() {
  if ! $git status -s &> /dev/null; then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]; then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

# Function to extract and display current branch name
git_prompt_info() {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
 echo "${ref#refs/heads/}"
}

# Function to list commits that have not been pushed to the upstream branch
unpushed() {
  $git cherry -v @{upstream} 2>/dev/null
}

# Function to determine if there are unpushed changes
need_push() {
  if $($git rev-parse --is-inside-work-tree 2>/dev/null); then
    number=$($git cherry -v origin/$($git symbolic-ref --short HEAD) 2>/dev/null | wc -l | bc)

    if [[ $number == 0 ]]; then
      echo " "
    else
      echo " with %{$fg_bold[magenta]%}$number unpushed%{$reset_color%}"
    fi
  fi
}

# Function to display the current directory name
directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

# Set up the main shell prompt
export PROMPT=$'\n$(directory_name) $(git_dirty)$(need_push)\n> '

# Function to set up the right-side prompt (RPROMPT)
set_prompt() {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

# Function to execute before each command prompt (precmd)
precmd() {
  set_prompt
}
