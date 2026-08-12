#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

source $HOME/.bashenv

export EDITOR="nvim"

alias ls='ls --color=auto'
alias ll='ls -alh'
alias grep='grep --color=auto'

alias ..='cd ..'

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

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

parse_nix_flake() {
        if [ -n "$FLAKE_NAME" ]; then
                echo " (nix:$FLAKE_NAME)"
        fi
}

PS1="\$(EXIT=\$?; if [ \$EXIT -eq 0 ]; then echo \"\[\e[38;5;243m\][\$EXIT]\"; else echo \"\[\e[1;38;5;167m\][\$EXIT]\"; fi)\[\e[m\] \[\e[38;5;142m\]\u\[\e[m\]@\[\e[38;5;108m\]\h \[\e[38;5;214m\]\w\[\e[38;5;109m\]\$(parse_nix_flake)\[\e[38;5;167m\]\$(parse_git_status)\[\e[m\] \$ "
