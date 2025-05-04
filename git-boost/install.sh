#!/bin/zsh

INSTALL_DIR="$HOME/.local/bin"
SHARE_DIR="$HOME/.local/share/git-boost"
TEMPLATES_DIR="$SHARE_DIR/templates"
SCRIPT_NAME="git-boost"
ZSHRC="$HOME/.zshrc"

mkdir -p "$INSTALL_DIR"
mkdir -p "$TEMPLATES_DIR"  # Create templates directory

# Copy the script and templates
cp git-boost.sh "$INSTALL_DIR/$SCRIPT_NAME"
cp -r templates/* "$TEMPLATES_DIR/"

chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Log template placement
echo "[INFO] Templates copied to $TEMPLATES_DIR"

echo "[INFO] Installed $SCRIPT_NAME to $INSTALL_DIR"

# Add to PATH if not already in .zshrc
if ! grep -q "$INSTALL_DIR" "$ZSHRC" 2>/dev/null; then
  echo "\n# Added by git-boost installer" >> "$ZSHRC"
  echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$ZSHRC"
  echo "[INFO] Added $INSTALL_DIR to PATH in $ZSHRC"
  echo "[INFO] Please run 'source ~/.zshrc' or restart terminal to use 'git-boost' globally."
else
  echo "[INFO] $INSTALL_DIR already in PATH"
fi
