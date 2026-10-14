#!/usr/bin/env bash
set -u

usage() {
  echo "Usage: $0 [tree-file] [target-directory]" >&2
  echo "  tree-file       file containing the project tree (default: project_tree.txt)" >&2
  echo "  target-directory where to create the structure (default: .)" >&2
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

TREE_FILE="${1:-project_tree.txt}"
TARGET_DIR="${2:-.}"

if [[ ! -f "$TREE_FILE" ]]; then
  echo "Tree file not found: $TREE_FILE" >&2
  usage
  exit 1
fi

TREE_FILE="$(cd "$(dirname "$TREE_FILE")" 2>/dev/null && pwd)/$(basename "$TREE_FILE")"
mkdir -p "$TARGET_DIR"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

# Tracks the current directory stack while walking the tree.
declare -a stack=()
line_no=0

while IFS= read -r raw || [[ -n "$raw" ]]; do
  raw="${raw%$'\r'}"
  [[ -z "$raw" ]] && continue

  line_no=$((line_no + 1))

  # Ignore the root label line such as: "rag-chatbot/"
  if (( line_no == 1 )) && [[ "$raw" == *"/" ]] && [[ "$raw" != *"│"* ]] && [[ "$raw" != *"├"* ]] && [[ "$raw" != *"└"* ]]; then
    continue
  fi

  normalized="${raw//│/ }"
  normalized="${normalized//├/ }"
  normalized="${normalized//└/ }"
  normalized="${normalized//─/ }"
  normalized="${normalized//|/ }"

  prefix="${normalized%%[![:space:]]*}"
  spaces="${#prefix}"
  depth=$(( (spaces + 3) / 4 ))

  # Remove leading spaces created by the tree drawing.
  entry="${normalized#"$prefix"}"
  entry="${entry#"${entry%%[![:space:]]*}"}"
  entry="${entry%"${entry##*[![:space:]]}"}"

  # Remove any remaining tree drawing characters if present.
  entry="${entry//│/}"
  entry="${entry//├/}"
  entry="${entry//└/}"
  entry="${entry//─/}"
  entry="${entry//|/}"
  entry="${entry#"${entry%%[![:space:]]*}"}"
  entry="${entry%"${entry##*[![:space:]]}"}"

  [[ -z "$entry" ]] && continue

  is_dir=false
  if [[ "$entry" == */ ]]; then
    is_dir=true
    entry="${entry%/}"
  fi

  [[ -z "$entry" ]] && continue

  while (( ${#stack[@]} >= depth )); do
    unset 'stack[${#stack[@]}-1]'
  done

  target_path="$TARGET_DIR"
  for item in "${stack[@]}"; do
    target_path+="/$item"
  done

  if $is_dir; then
    target_path+="/$entry"
    mkdir -p "$target_path"
    stack+=("$entry")
  else
    target_path+="/$entry"
    mkdir -p "$(dirname "$target_path")"
    touch "$target_path"
  fi
done < "$TREE_FILE"

echo "Created project structure under $TARGET_DIR"
echo "Done."
