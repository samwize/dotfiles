# Managed by chezmoi.

# Homebrew-installed VS Code exposes `code` here.
if [ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]; then
  path+=("/Applications/Visual Studio Code.app/Contents/Resources/app/bin")
fi

# Solana (installed via official installer).
if [ -d "$HOME/.local/share/solana/install/active_release/bin" ]; then
  path+=("$HOME/.local/share/solana/install/active_release/bin")
fi

