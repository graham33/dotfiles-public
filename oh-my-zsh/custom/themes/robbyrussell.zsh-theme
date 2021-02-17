PROMPT="${USER}@%M %(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT+=' %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

CURRENT_BG='NONE'

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# nix-shell: currently running nix-shell
prompt_nix_shell() {
  if [[ -n "$IN_NIX_SHELL" ]]; then
    if [[ -n $NIX_SHELL_PACKAGES ]]; then
      local package_names=""
      local packages=($NIX_SHELL_PACKAGES)
      for package in $packages; do
        package_names+=" ${package##*.}"
      done
      prompt_segment default yellow "[$package_names]"
    elif [[ -n $name ]]; then
      local cleanName=${name#interactive-}
      cleanName=${cleanName%-environment}
      prompt_segment default yellow "[$cleanName]"
    else # This case is only reached if the nix-shell plugin isn't installed or failed in some way
      prompt_segment default yellow "nix-shell []"
    fi
  fi
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}$(prompt_nix_shell)$(prompt_end) "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
