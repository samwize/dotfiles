# Managed by chezmoi.

gac() {
  git add .
  git commit -a -m "$1"
}

gacp() {
  git add .
  git commit -a -m "$1"
  git push
}

gdelete() {
  git branch --delete "$1"
  git push origin --delete "$1"
}

jn() {
  if ! command -v toolbelt >/dev/null 2>&1; then
    echo "jn: toolbelt not found" >&2
    return 127
  fi

  if [[ "${1:-}" == "-d" || "${1:-}" == "--dir" ]]; then
    toolbelt journal new "$@"
    return
  fi

  if [[ $# -ge 2 && -d "$1" ]]; then
    local dir="$1"
    shift
    toolbelt journal new -d "$dir" "$@"
    return
  fi

  toolbelt journal new -d "$PWD" "$@"
}
