#!/bin/zsh

# git-boost.sh v1.0.0
# A utility script to streamline GitHub repo setup and standardization

VERSION="1.0.0"
SCRIPT_NAME="git-boost"
SCRIPT_PATH="$(realpath "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# Set the templates directory to the correct location
TEMPLATES_DIR="$HOME/.local/share/git-boost/templates"  # Corrected path to templates

DEFAULT_GIT_USER=""
DEFAULT_GIT_EMAIL=""

# To hold log of actions performed
SUMMARY_LOG=()

# Check and install gum if not available
function check_gum() {
  if ! command -v gum &>/dev/null; then
    echo "\n[GIT-BOOST] Installing 'gum' for interactive prompts..."
    brew install gum || { echo "Install Homebrew first or install gum manually."; exit 1; }
  fi
}

# Set Git config if not already set
function ensure_git_config() {
  local user=$(git config user.name)
  local email=$(git config user.email)
  if [[ -z "$user" ]]; then
    user=$(gum input --placeholder "Enter Git username")
    git config --local user.name "$user"
  fi
  if [[ -z "$email" ]]; then
    email=$(gum input --placeholder "Enter Git email")
    git config --local user.email "$email"
  fi
}

# Case-insensitive check for file existence
function has_file_ci() {
  local name="$1"
  find . -maxdepth 1 -type f -iname "$name" | grep -q .
}

# Skip non-user-generated folders like .git, .DS_Store
function is_user_generated() {
  local dir="$1"
  [[ "$dir" != ".git" && "$dir" != ".DS_Store" && ! "$dir" =~ ^\..* ]] # skip hidden dirs except user ones
}

# Add standard files if missing
function add_standard_files() {
  local added=()

  for file in README.md LICENSE CONTRIBUTING.md; do
    if ! has_file_ci "$file"; then
      cp "$TEMPLATES_DIR/$file" "$file"  # Using the corrected templates directory
      added+=("$file")
    fi
  done

  if (( ${#added[@]} > 0 )); then
    git add ${added[@]}
    local msg="Added ${added[*]}"
    git commit -m "$msg"
    SUMMARY_LOG+=("Added files: ${added[*]}")
  else
    SUMMARY_LOG+=("No standard files added.")
  fi
}

# Save uncommitted changes, switch to master, apply changes, then switch back
function handle_branch_switch() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "$current_branch" != "master" ]]; then
    git stash push -m "Saving changes before switching to master" || { echo "[ERROR] Failed to stash changes."; return 1; }
    git checkout master || { echo "[ERROR] Failed to checkout master."; return 1; }
    git pull origin master || { echo "[ERROR] Failed to pull latest master."; return 1; }
  fi
}

# Init new repo from remote
function init_repo() {
  local url=$1
  local repo=$(basename "$url" .git)

  echo "\n[GIT-BOOST] Cloning $repo..."
  git clone "$url" || { echo "[ERROR] Failed to clone repo from $url."; return 1; }
  cd "$repo" || { echo "[ERROR] Failed to navigate to $repo."; return 1; }

  ensure_git_config || return 1
  add_standard_files || return 1

  git push origin master || { echo "[ERROR] Failed to push to $repo."; return 1; }
}

# Link local dir to GitHub repo
function link_repo() {
  local dirs=($(find . -maxdepth 1 -type d -not -name ".git" -not -name ".DS_Store"))
  
  # Use gum to choose a directory
  local choice=$(gum choose --header="Choose local directory to link" "${dirs[@]}")

  if [[ -z "$choice" ]]; then
    echo "[ERROR] No directory selected."
    return 1
  fi

  echo "\n[GIT-BOOST] Linking to $choice..."

  cd "$choice" || { echo "[ERROR] Failed to navigate to $choice."; return 1; }

  # Check if the remote origin is already set
  local remote_url=$(git remote get-url origin 2>/dev/null)

  if [[ -z "$remote_url" ]]; then
    # If no remote origin is set, ask for the GitHub repo URL
    local url=$(gum input --placeholder "Enter GitHub repo URL")
    git remote add origin "$url" || { echo "[ERROR] Failed to set remote origin."; return 1; }
  else
    # If remote origin is already set, skip asking for the URL
    echo "[GIT-BOOST] Remote 'origin' already set to $remote_url. Skipping URL input."
  fi

  [ -d ".git" ] || {
    gum confirm "Git not initialized in $choice. Initialize now?" && git init || { echo "[ERROR] Failed to initialize git."; return 1; }
  }

  ensure_git_config || return 1
  add_standard_files || return 1

  git push origin master || { echo "[ERROR] Failed to push to $choice."; return 1; }
  SUMMARY_LOG+=("Successfully linked and pushed $choice")
}

# Standardize one or all repos in a directory
function standardize_repos() {
  local root="$1"
  local repos=($(find "$root" -maxdepth 1 -type d -not -name ".git" -not -name ".DS_Store"))
  local choice=$(gum choose --header="Choose repo to standardize" All ${repos[@]})

  if [[ "$choice" == "All" ]]; then
    for repo in ${repos[@]}; do
      if ! is_user_generated "$(basename "$repo")"; then
        continue
      fi
      cd "$repo" || continue

      echo "\n[GIT-BOOST] Standardizing $(basename "$repo")"
      
      handle_branch_switch || { echo "[ERROR] Failed to handle branch switch in $repo."; continue; }

      ensure_git_config || { echo "[ERROR] Git config failed in $repo."; continue; }
      add_standard_files || { echo "[ERROR] Failed to add standard files to $repo."; continue; }

      git remote get-url origin &>/dev/null && git push origin master || echo "[ERROR] Failed to push $repo (no remote 'origin')"
      
      SUMMARY_LOG+=("Successfully standardized $repo")
      cd - >/dev/null
    done
  else
    cd "$choice" || { echo "[ERROR] Failed to navigate to $choice."; return 1; }

    handle_branch_switch || { echo "[ERROR] Failed to handle branch switch."; return 1; }

    ensure_git_config || { echo "[ERROR] Git config failed."; return 1; }
    add_standard_files || { echo "[ERROR] Failed to add standard files."; return 1; }

    git remote get-url origin &>/dev/null && git push origin master || echo "[ERROR] Failed to push to $choice (no remote 'origin')"

    SUMMARY_LOG+=("Successfully standardized $choice")
  fi
}

# Manual help
function show_manual() {
  cat <<EOF
$SCRIPT_NAME v$VERSION

Usage:
  $SCRIPT_NAME --init <repo-url>              Initialize new repo from GitHub
  $SCRIPT_NAME --link <dir> <repo-url>        Link local dir to GitHub and push
  $SCRIPT_NAME --standardize <root-dir>       Standardize all/specific repos
  $SCRIPT_NAME man                            Show manual

Interactive Mode:
  Run without args to enter menu-based mode.
EOF
}

# Show version
function show_version() {
  echo "$SCRIPT_NAME version $VERSION"
}

# Interactive entrypoint
function interactive_menu() {
  local action=$(gum choose --header="Choose an action" "Init new repo" "Link local dir" "Standardize repos")

  case "$action" in
    "Init new repo")
      local url=$(gum input --placeholder "Enter GitHub repo URL")
      init_repo "$url" || return 1
      ;;
    "Link local dir")
      link_repo || return 1
      ;;
    "Standardize repos")
      local path=$(gum input --placeholder "Enter base directory path")
      standardize_repos "$path" || return 1
      ;;
  esac
}

# Entrypoint with argument validation
check_gum

if [[ -z "$1" ]]; then
  # No arguments passed, start interactive menu
  interactive_menu || exit 1
  exit 0
fi

# Handle known commands
case "$1" in
  --init)
    init_repo "$2" || exit 1
    ;;
  --link)
    link_repo "$2" "$3" || exit 1
    ;;
  --standardize)
    standardize_repos "$2" || exit 1
    ;;
  --version)
    show_version
    ;;
  man)
    show_manual
    ;;
  *)
    # Handle incorrect arguments by showing the manual
    echo "[ERROR] Invalid argument '$1'. Please see the usage below."
    show_manual
    exit 1
    ;;
esac

# Summary log of actions performed only for --init, --link, --standardize
if [[ "$1" != "--version" && "$1" != "man" ]]; then
  echo "\n[GIT-BOOST] Summary of actions performed:"
  for entry in "${SUMMARY_LOG[@]}"; do
    echo "$entry"
  done
fi
