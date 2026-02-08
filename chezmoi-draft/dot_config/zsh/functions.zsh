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

