# .zshrc

## Generic Requirements
### * git
### * thefuck

## Arch
### * pkgfile

#zmodload zsh/zprof

## Installing zi zsh package manager from https://github.com/zdharma/zi
if [[ ! -f "$HOME/.config/zsh/zi/zi.zsh" ]]; then
  gitprog=$(command -v git)
  if [[ -z "$gitprog" ]]; then
    echo "git is not installed but required to further setup zsh." >&2
  else
    mkdir -p "$HOME/.config/zsh/zi"
    git clone https://github.com/zdharma/zi.git "$HOME/.config/zsh/zi"
  fi
fi

source "$HOME/.config/zsh/zi/zi.zsh"

## Bind keys

### emacs key bindings
bindkey -e

### create a zkbd compatible hash;
### to add other keys to this hash, see: man 5 terminfo
typeset -g -A key
keyArray=(
  Home:"${terminfo[khome]}":beginning-of-line
  End:"${terminfo[kend]}":end-of-line
  Insert:"${terminfo[kich1]}":overwrite-mode
  Backspace:"${terminfo[kbs]}":backward-delete-char
  Delete:"${terminfo[kdch1]}":delete-char
  Up:"${terminfo[kcuu1]}":up-line-or-history
  Down:"${terminfo[kcud1]}":down-line-or-history
  Left:"${terminfo[kcub1]}":backward-char
  Right:"${terminfo[kcuf1]}":forward-char
  PageUp:"${terminfo[kpp]}":up-line-or-history
  PageDown:"${terminfo[knp]}":down-line-or-history
  'Shift-Tab':"${terminfo[kcbt]}":reverse-menu-complete
)

for key_data in ${(kv)keyArray}; do
  local keyArray=("${(@s/:/)key_data}") # split the key_data string on colons to get the key code, the key label, and the function name
  if [[ -n $keyArray[3] ]]; then        # only bind the key if a function name is provided
    bindkey -- "${keyArray[2]}" "${keyArray[3]}"
  fi
done
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

## Make sure the terminal is in application mode, when zle is active.
## Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
      autoload -Uz add-zle-hook-widget
      function zle_application_mode_start { echoti smkx }
      function zle_application_mode_stop { echoti rmkx }
      add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
      add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

## Completion
zstyle ':completion:*' menu select     # select completions with arrow keys
zstyle ':completion:*' group-name ''   # group results by category
zstyle ':completion:*' rehash true
zstyle ':completion:::::' completer _expand _complete _ignored _approximate #enable approximate matches for completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Enable LS_COLORS for the completion of files and directories.
#zstyle ':completion:*' completer _complete _ignored
#zstyle :compinstall filename '$HOME/.config/zsh/.zshrc'

## Enable syntax highlighting
zi wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zi creinstall -q .' \
      zsh-users/zsh-completions

## This must be after syntax highlighting and before completions
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

## Load scripts from $HOME/.local/bin/zsh/
## Must be after bashcompinit
if [[ -d "$HOME/.local/bin/zsh" ]]; then
  for script in "$HOME"/.local/bin/zsh/*; do
    if [[ -f $script ]]; then
      source "$script"
    fi
  done
fi

## Set history options
export DIRENV_LOG_FORMAT=
HISTFILE="$HOME/.config/zsh/zsh.history"
HISTSIZE=100000
SAVEHIST="$HISTSIZE"
setopt hist_ignore_all_dups  # remove older duplicate entries from history
setopt hist_reduce_blanks    # remove superfluous blanks from history items
setopt inc_append_history    # save history entries as soon as they are entered
setopt share_history         # share history between different instances of the shell

## Enable auto corrections and insertions
setopt auto_cd        # cd by typing directory name if it's not a command
setopt auto_list      # automatically list choices on ambiguous completion
setopt auto_menu      # automatically use menu completion
setopt always_to_end  # move cursor to end if word had one match
#setopt correct_all   # autocorrect commands
#setopt COMPLETE_ALIASES

## Fuzzy search history
### start typing + [Up-Arrow] - fuzzy find history forward
#if [[ "${terminfo[kcuu1]}" != "" ]]; then
#  autoload -U up-line-or-beginning-search
#  zle -N up-line-or-beginning-search
#  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
#fi
### start typing + [Down-Arrow] - fuzzy find history backward
#if [[ "${terminfo[kcud1]}" != "" ]]; then
#  autoload -U down-line-or-beginning-search
#  zle -N down-line-or-beginning-search
#  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
#fi

#if type rg &> /dev/null; then
#  export FZF_DEFAULT_COMMAND='rg --files'
#  export FZF_DEFAULT_OPTS='-m --height 50% --border'
#fi

## Notifications
zi ice wait lucid \
  atload"AUTO_NOTIFY_IGNORE+=(emacs mpgo mpv ranger rn vim vimus neomutt)"
zi light "MichaelAquilina/zsh-auto-notify" # automatically sends out a notification when a long running task has completed
AUTO_NOTIFY_IGNORE+=("docker" "ssh")

## Load or unload ENV variables from .envrc file depending on the current directory
zi ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
  atpull'%atclone' src"zhook.zsh"
zi light direnv/direnv

## Multi-word, syntax highlighted history searching for Zsh
zstyle ":history-search-multi-word" page-size "11"
zi ice wait"1" lucid
zi light zdharma/history-search-multi-word

## Multiple OhMyZSH plugins
zi light skywind3000/z.lua          # navigate faster by learning your habits
zi snippet OMZP::command-not-found  # provide suggested packages to be installed if a command cannot be found
zi snippet OMZP::extract            # extracts a wide variety of archive filetypes
#zi snippet OMZP::thefuck            # corrects your previous console command

## Colored man pages
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_us=$(tput bold; tput setaf 2)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)

#zprof

## Better CLI experience
eval "$(starship init zsh)"
