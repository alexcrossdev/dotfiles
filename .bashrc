#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

source $HOME/.bashenv

export EDITOR="nvim"
export PATH="$HOME/.local/bin:$PATH"

alias ls='ls --color=auto'
alias ll='ls -alh'
alias grep='grep --color=auto'

alias ..='cd ..'

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

WAL_COLORS="${WAL_COLORS:-$HOME/.cache/wal/colors.sh}"

wal_ansi256_nearest() {
  local hex="$1" r g b
  hex="${hex#\#}"
  r=$((16#${hex:0:2}))
  g=$((16#${hex:2:2}))
  b=$((16#${hex:4:2}))

  local best=0 bestd=
  local i rr gg bb d

  for i in {0..255}; do
    if [ "$i" -le 15 ]; then
      case $i in
        0) rr=0; gg=0; bb=0;;
        1) rr=128; gg=0; bb=0;;
        2) rr=0; gg=128; bb=0;;
        3) rr=128; gg=128; bb=0;;
        4) rr=0; gg=0; bb=128;;
        5) rr=128; gg=0; bb=128;;
        6) rr=0; gg=128; bb=128;;
        7) rr=192; gg=192; bb=192;;
        8) rr=128; gg=128; bb=128;;
        9) rr=255; gg=0; bb=0;;
        10) rr=0; gg=255; bb=0;;
        11) rr=255; gg=255; bb=0;;
        12) rr=0; gg=0; bb=255;;
        13) rr=255; gg=0; bb=255;;
        14) rr=0; gg=255; bb=255;;
        15) rr=255; gg=255; bb=255;;
      esac
    elif [ "$i" -ge 16 ] && [ "$i" -le 231 ]; then
      local x=$((i-16))
      local rc=$((x/36))
      local gc=$(((x%36)/6))
      local bc=$((x%6))
      rr=$(( rc==0 ? 0 : 55 + rc*40 ))
      gg=$(( gc==0 ? 0 : 55 + gc*40 ))
      bb=$(( bc==0 ? 0 : 55 + bc*40 ))
    else
      local t=$((i-232))
      rr=$((8 + t*10))
      gg=$rr
      bb=$rr
    fi

    d=$(( (r-rr)*(r-rr) + (g-gg)*(g-gg) + (b-bb)*(b-bb) ))
    if [ -z "$bestd" ] || [ "$d" -lt "$bestd" ]; then
      bestd="$d"
      best="$i"
    fi
  done

  echo "$best"
}

__wal_update_prompt() {
  [ -r "$WAL_COLORS" ] && . "$WAL_COLORS"

  local user_hex="${color2}"  # user color
  local host_hex="${color6}"  # host color
  local path_hex="${color5}"  # PATH/W origin color (change color5 to whatever you want)

  local user_ansi host_ansi path_ansi
  user_ansi="$(wal_ansi256_nearest "$user_hex")"
  host_ansi="$(wal_ansi256_nearest "$host_hex")"
  path_ansi="$(wal_ansi256_nearest "$path_hex")"

  PS1="\$(
    EXIT=\$?; if [ \$EXIT -eq 0 ]; then echo \"\[\e[38;5;243m\][\$EXIT]\"; else echo \"\[\e[1;38;5;167m\][\$EXIT]\"; fi
  )\[\e[m\] \[\e[38;5;${user_ansi}m\]\u\[\e[m\]@\[\e[38;5;${host_ansi}m\]\h \
\[\e[38;5;${path_ansi}m\]\w\$(parse_nix_flake)\[\e[38;5;74m\]\$(parse_cronus_status)\[\e[38;5;167m\]\$(parse_git_status)\[\e[m\] \$ "
}

PROMPT_COMMAND='__wal_update_prompt'
# Git status
parse_git_status() {
        if ! git rev-parse --is-inside-work-tree &>/dev/null; then
                return
        fi

        local BRANCH=$(git branch --show-current 2>/dev/null)
        if [ -z "$BRANCH" ]; then
                # Fallback for detached HEAD
                BRANCH=$(git rev-parse --short HEAD 2>/dev/null)
        fi

        local STATUS=$(git status --porcelain 2>/dev/null)
        local GIT_DIRTY=""

        if echo "$STATUS" | grep -q '^[A-Z]'; then
                GIT_DIRTY="${GIT_DIRTY}*"
        fi

        if echo "$STATUS" | grep -q '^.[A-Z]'; then
                GIT_DIRTY="${GIT_DIRTY}+"
        fi

        if echo "$STATUS" | grep -q '??'; then
                GIT_DIRTY="${GIT_DIRTY}?"
        fi

        local UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
        if [ -n "$UPSTREAM" ]; then
                local LOCAL=$(git rev-parse @ 2>/dev/null)
                local REMOTE=$(git rev-parse @{u} 2>/dev/null)
                local BASE=$(git merge-base @ @{u} 2>/dev/null)

                if [ "$LOCAL" = "$REMOTE" ]; then
                        :
                elif [ "$LOCAL" = "$BASE" ]; then
                        GIT_DIRTY="${GIT_DIRTY}v"
                elif [ "$REMOTE" = "$BASE" ]; then
                        GIT_DIRTY="${GIT_DIRTY}^"
                else
                        GIT_DIRTY="${GIT_DIRTY}x"
                fi
        fi

        if [ -n "$GIT_DIRTY" ]; then
                echo " (git:$BRANCH $GIT_DIRTY)"
        else
                echo " (git:$BRANCH)"
        fi
}

# Cronus status
parse_cronus_status() {
	if ! cronus parse --is-in-working-tree &>/dev/null; then
		return
	fi

	echo " (cronus:master)"
}

# Flake status
parse_nix_flake() {
    if [[ -f "flake.nix" && ! -v FLAKE ]]; then
        echo -e " \033[38;5;242m[flake]\033[0m"
    elif [[ -n "$FLAKE" ]]; then
        echo -e " \033[38;5;103m[flake]\033[0m"
    fi
}

# Move into dir before starting nvim
nvim() {
	if [ -d "$1" ]; then
		(
			cd "$1" || return
			command nvim .
		)
	else
		command nvim "$@"
	fi
}

