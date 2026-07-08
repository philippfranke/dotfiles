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

# Determine the path for the jj command (optional).
if (( $+commands[jj] )); then
  jj="${commands[jj]}"
else
  jj=""
fi

# in_jj_repo / in_git_repo / vcs live in zsh/vcs.zsh (shared helpers).

# Function to extract the current jj "branch", git-describe style: the
# nearest ancestor bookmark plus how many changes @ is past it
# (e.g. "master", "master+2"), falling back to the short change id when
# no bookmark exists anywhere in the ancestry. An empty working-copy
# commit is not counted, so sitting clean on master shows "master"
# (not "master+1"). --ignore-working-copy keeps the prompt read-only
# (no snapshot / new operation per prompt).
jj_prompt_info() {
  local nb ahead
  nb=$($jj --ignore-working-copy log --no-graph --color never \
    -r 'latest(::@ & bookmarks())' \
    -T 'local_bookmarks.map(|b| b.name()).join(",")' 2>/dev/null)
  if [[ -z "$nb" ]]; then
    $jj --ignore-working-copy log --no-graph --color never -r @ \
      -T 'change_id.shortest(8)' 2>/dev/null
    return
  fi
  ahead=$($jj --ignore-working-copy log --no-graph --color never \
    -r 'latest(::@ & bookmarks())..@ ~ (@ & empty())' -T '"x"' 2>/dev/null)
  if [[ -n "$ahead" ]]; then
    echo "${nb}+${#ahead}"
  else
    echo "$nb"
  fi
}

# Function to colorize the jj info by working-copy state (empty == clean).
jj_dirty() {
  local state
  state=$($jj --ignore-working-copy log --no-graph --color never -r @ \
    -T 'if(empty, "clean", "dirty")' 2>/dev/null) || return
  if [[ $state == "clean" ]]; then
    echo "on %{$fg_bold[green]%}jj:$(jj_prompt_info)%{$reset_color%}"
  else
    echo "on %{$fg_bold[red]%}jj:$(jj_prompt_info)%{$reset_color%}"
  fi
}

# Function to get the current git branch
git_branch() {
  echo "$($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})"
}

# Function to determine if the current git directory is dirty (changes are uncommitted)
git_dirty() {
  if in_jj_repo; then
    jj_dirty
    return
  fi
  if ! $git status -s &> /dev/null; then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]; then
      echo "on %{$fg_bold[green]%}git:$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}git:$(git_prompt_info)%{$reset_color%}"
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
  if in_jj_repo; then
    return
  fi
  if $($git rev-parse --is-inside-work-tree 2>/dev/null); then
    number=$($git cherry -v origin/$($git symbolic-ref --short HEAD 2>/dev/null) 2>/dev/null | wc -l | bc)

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
