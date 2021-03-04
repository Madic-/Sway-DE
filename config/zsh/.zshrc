# .zshrc

## Generic Requirements
### * git
### * thefuck

## Arch
### * pkgfile

## Installing package manager
if [[ ! -d $HOME/.config/zsh/zinit ]];then
  mkdir $HOME/.config/zsh/zinit
  git clone https://github.com/zdharma/zinit.git $HOME/.config/zsh/zinit
fi
source $HOME/.config/zsh/zinit/zinit.zsh

export DIRENV_LOG_FORMAT=

for f in $HOME/.local/bin/zsh/*.sh; do source $f; done

HISTFILE=$HOME/.bash_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:*' rehash true
zstyle ':completion:::::' completer _expand _complete _ignored _approximate #enable approximate matches for completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Enable LS_COLORS for the completion of files and directories.

#zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '$HOME/.config/zsh/.zshrc'

setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell
setopt auto_cd # cd by typing directory name if it's not a command
#setopt correct_all # autocorrect commands
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
#setopt COMPLETE_ALIASES

autoload -Uz compinit && compinit

bindkey -e

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
      autoload -Uz add-zle-hook-widget
      function zle_application_mode_start { echoti smkx }
      function zle_application_mode_stop { echoti rmkx }
      add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
      add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

#zinit ice wait lucid \
#  atload"AUTO_NOTIFY_IGNORE+=(emacs mpgo mpv ranger rn vim vimus)"
zinit light "MichaelAquilina/zsh-auto-notify" # automatically sends out a notification when a long running task has completed
AUTO_NOTIFY_IGNORE+=("docker" "ssh")

# load or unload ENV variables from .envrc file depending on the current directory
zinit from"gh-r" as"program" mv"direnv* -> direnv" \
    atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
    pick"direnv" src="zhook.zsh" for \
        direnv/direnv

# Multi-word, syntax highlighted history searching for Zsh
zstyle ":history-search-multi-word" page-size "11"
zinit ice wait"1" lucid
zinit light zdharma/history-search-multi-word

zinit light skywind3000/z.lua # navigate faster by learning your habits
zinit snippet OMZP::command-not-found # provide suggested packages to be installed if a command cannot be found
zinit snippet OMZP::extract # extracts a wide variety of archive filetypes
zinit snippet OMZP::thefuck # corrects your previous console command

# Colored man pages
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_us=$(tput bold; tput setaf 2)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)

eval "$(starship init zsh)"
