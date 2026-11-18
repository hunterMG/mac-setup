# 1. Core PATH/env, no slow commands.
export EDITOR='nvim'
export VISUAL="$EDITOR"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS=1
export LANG=en_US.UTF-8
export ANDROID_HOME=$HOME/Library/Android/sdk
export MONGO_URI='mongodb://localhost:27017/'
export PNPM_HOME="$HOME/Library/pnpm"
export PYTHONPYCACHEPREFIX="$HOME/.cache/python"
export HF_ENDPOINT="https://hf-mirror.com"
export HUGGINGFACE_MIRROR="https://hf-mirror.com"
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
setopt NO_HUP

# 2. Cache common expensive paths once.
if command -v brew >/dev/null 2>&1; then
  BREW_PREFIX="$(brew --prefix)"
else
  BREW_PREFIX="/usr/local"
fi

# 3. Deduplicate zsh path arrays.
typeset -U path fpath
path=(
  "$HOME/.local/bin"
  "$PNPM_HOME"
  "$PNPM_HOME/bin"
  "$BREW_PREFIX/opt/lua/bin"
  "$HOME/Library/Python/3.11/bin"
  "$HOME/go/bin"
  "/Library/TeX/texbin"
  "$BREW_PREFIX/opt/python/libexec/bin"
  "$BREW_PREFIX/opt/ruby/bin"
  "$BREW_PREFIX/opt/openssl/bin"
  "$BREW_PREFIX/opt/luajit-openresty/bin"
  "$BREW_PREFIX/opt/curl/bin"
  "$BREW_PREFIX/opt/ffmpeg@7/bin"
  "$HOME/.gem/bin"
  "$ANDROID_HOME/platform-tools"
  "$ANDROID_HOME/tools"
  "$HOME/.lmstudio/bin"
  "$HOME/.antigravity/antigravity/bin"
  "$HOME/.antigravity-ide/antigravity-ide/bin"
  "/Applications/DevEco-Studio.app/Contents/tools/emulator"
  "$path[@]"
)
# GPG / pinentry needs the current terminal for each interactive shell.
if tty -s; then
  export GPG_TTY="$(tty)"
  command -v gpgconf >/dev/null 2>&1 && gpgconf --launch gpg-agent >/dev/null 2>&1
fi
# Java begin ------------------------------------------------------------------
JAVA_8_HOME="$HOME/Library/Java/JavaVirtualMachines/corretto-1.8.0_302/Contents/Home"
JAVA_11_HOME="/Library/Java/JavaVirtualMachines/jdk-11.0.8.jdk/Contents/Home"
JAVA_16_HOME="$BREW_PREFIX/Cellar/openjdk/16.0.2"
JAVA_17_HOME="$BREW_PREFIX/opt/openjdk@17"
JAVA_25_HOME="$BREW_PREFIX/opt/openjdk@25"

juse() {
  case "$1" in
    8)  local next_java="$JAVA_8_HOME" ;;
    11) local next_java="$JAVA_11_HOME" ;;
    16) local next_java="$JAVA_16_HOME" ;;
    17) local next_java="$JAVA_17_HOME" ;;
    25) local next_java="$JAVA_25_HOME" ;;
    *)
      echo "usage: juse 8|11|16|17|25" >&2; return 2 ;;
  esac

  if [[ ! -d "$next_java" || ! -x "$next_java/bin/java" ]]; then
    echo "juse: Java $1 not found or incomplete: $next_java" >&2
    return 1
  fi

  path=("${path[@]:#$JAVA_8_HOME/bin}")
  path=("${path[@]:#$JAVA_11_HOME/bin}")
  path=("${path[@]:#$JAVA_16_HOME/bin}")
  path=("${path[@]:#$JAVA_17_HOME/bin}")
  path=("${path[@]:#$JAVA_25_HOME/bin}")

  export JAVA_HOME="$next_java"
  path=("$JAVA_HOME/bin" "$path[@]")
  typeset -U path
}

juse 17
## Java end -------------------------------------------------------------------
# Ruby
export GEM_HOME="$HOME/.gem"
# GoLang
export GO111MODULE=on
export GOPROXY=https://goproxy.io

# Build flags
export LDFLAGS="\
-L$BREW_PREFIX/opt/lua/lib \
-L$BREW_PREFIX/opt/ruby/lib \
-L$BREW_PREFIX/opt/openssl/lib \
-L$BREW_PREFIX/opt/luajit-openresty/lib \
-L$BREW_PREFIX/opt/curl/lib"

export CPPFLAGS="\
-I$BREW_PREFIX/opt/lua/include \
-I$BREW_PREFIX/opt/ruby/include \
-I$BREW_PREFIX/opt/openssl/include \
-I$BREW_PREFIX/opt/luajit-openresty/include \
-I$BREW_PREFIX/opt/curl/include"

export PKG_CONFIG_PATH="\
$BREW_PREFIX/opt/lua/lib/pkgconfig:\
$BREW_PREFIX/opt/ruby/lib/pkgconfig:\
$BREW_PREFIX/opt/openssl/lib/pkgconfig:\
$BREW_PREFIX/opt/luajit-openresty/lib/pkgconfig:\
$BREW_PREFIX/opt/curl/lib/pkgconfig"

# 4. History config before OMZ.
# the number of commands that are loaded into memory from the history file
HISTSIZE=1000000000
# the number of commands that are stored in the zsh history file
SAVEHIST=1000000000
setopt appendhistory
# setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
# setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# 5. Completion paths before OMZ.
fpath=(
  "$HOME/.zsh_completions"
  "$HOME/.zsh_completions.local"
  "$BREW_PREFIX/share/zsh-completions"
  "$fpath[@]"
)

# 6. OMZ config before source.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="intheloop"
plugins=(git macos docker git-open)

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
command mkdir -p "$ZSH_CACHE_DIR"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

_zcomp_lock="$ZSH_COMPDUMP.compinit.lock"
# VS Code/Python probes are `zsh -i`, not login shells. iTerm2 sessions are usually login shells.
if [[ ! -o login ]]; then
  return 0 2>/dev/null || exit 0
fi
# if [[ ! -o interactive ]]; then
#   return 0
# fi

# Real terminal sessions wait their turn instead of skipping OMZ.
while ! mkdir "$_zcomp_lock" 2>/dev/null; do
  sleep 0.05
done

trap 'rmdir "$_zcomp_lock" 2>/dev/null' EXIT INT TERM

source "$ZSH/oh-my-zsh.sh"

rmdir "$_zcomp_lock" 2>/dev/null
trap - EXIT INT TERM

# 7 Interactive helpers (after source ohmyzsh)
eval "$(thefuck --alias)"
eval "$(lua "$BREW_PREFIX/opt/z.lua/share/z.lua/z.lua" --init zsh)"

# 7.1. Interactive plugins after OMZ.
for file in \
  "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "$HOME/.openclaw/completions/openclaw.zsh" \
  "$HOME/.iterm2_shell_integration.zsh"
do
  [[ -f "$file" ]] && source "$file"
done

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=23'

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# 7.2. helper functions and aliases after plugins.
## decode a base64 string
decode() {
    printf '%s' "$1" | base64 --decode 2>/dev/null || printf '%s' "$1" | base64 -D
    echo
}

[[ -f ~/.alias ]] && source ~/.alias

# Avoid duplicates in path/fpath after `zshreload`
typeset -U path fpath
path=("$path[@]")
fpath=("$fpath[@]")

# 8. prompt should be the last thing to load.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
