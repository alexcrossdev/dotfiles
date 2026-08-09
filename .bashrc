#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Git status parser for the prompt
parse_git_status() {
  # Check if in git repository
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    return
  fi

  # Get branch name
  local BRANCH=$(git branch --show-current 2>/dev/null)
  if [ -z "$BRANCH" ]; then
    # Fallback for detached HEAD
    BRANCH=$(git rev-parse --short HEAD 2>/dev/null)
  fi

  # Fetch raw status data
  local STATUS=$(git status --porcelain 2>/dev/null)
  local GIT_DIRTY=""

  # Check for changes to be committed (Staged)
  if echo "$STATUS" | grep -q '^[A-Z]'; then
    GIT_DIRTY="${GIT_DIRTY}*" # Clean star indicator for staged
  fi

  # Check for changes not staged for commit (Modified)
  if echo "$STATUS" | grep -q '^.[A-Z]'; then
    GIT_DIRTY="${GIT_DIRTY}+" # Low-profile standard plus sign for modified
  fi

  # Check for untracked files
  if echo "$STATUS" | grep -q '??'; then
    GIT_DIRTY="${GIT_DIRTY}?" # Clean question mark for untracked
  fi

  # Check upstream status (ahead/behind tracking for push/pull)
  local UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
  if [ -n "$UPSTREAM" ]; then
    local LOCAL=$(git rev-parse @ 2>/dev/null)
    local REMOTE=$(git rev-parse @{u} 2>/dev/null)
    local BASE=$(git merge-base @ @{u} 2>/dev/null)

    if [ "$LOCAL" = "$REMOTE" ]; then
      :
    elif [ "$LOCAL" = "$BASE" ]; then
      GIT_DIRTY="${GIT_DIRTY}v" # Low-profile down-arrow alternative
    elif [ "$REMOTE" = "$BASE" ]; then
      GIT_DIRTY="${GIT_DIRTY}^" # Low-profile up-arrow alternative
    else
      GIT_DIRTY="${GIT_DIRTY}x" # Cross for diverged
    fi
  fi

  # Format output wrapper matching Gruvbox styling
  if [ -n "$GIT_DIRTY" ]; then
    echo " (git:$BRANCH $GIT_DIRTY)"
  else
    echo " (git:$BRANCH)"
  fi
}

PS1="\$(EXIT=\$?; if [ \$EXIT -eq 0 ]; then echo \"\[\e[38;5;243m\][\$EXIT]\"; else echo \"\[\e[1;38;5;167m\][\$EXIT]\"; fi)\[\e[m\] \[\e[38;5;142m\]\u\[\e[m\]@\[\e[38;5;108m\]\h \[\e[38;5;214m\]\w\[\e[38;5;167m\]\$(parse_git_status)\[\e[m\] \$ "

