# >>> KAUTOLOG START >>>
# Auto logging (text + timing) for every interactive Zsh shell
if [[ -o interactive ]] && [[ -z "$UNDER_SCRIPT" ]]; then
  export UNDER_SCRIPT=1
  base="__KAUTOLOG_LOGDIR__/$(date +%Y)/$(date +%m)/$(date +%d)"
  mkdir -p "$base"
  logbase="$base/$(hostname)-$$-$(date +%H%M%S)"
  exec script -fqe --timing "$logbase.timing" "$logbase.log"
fi
# Timestamp + CWD marker before each prompt (Zsh)
function precmd() {
  printf "\n# [%s] %s\n" "$(date -Is)" "$(pwd)" >> "$logbase.log" 2>/dev/null
}
# <<< KAUTOLOG END <<<
