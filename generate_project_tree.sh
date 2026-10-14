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
cd "$TARGET_DIR" || exit 1

if command -v python >/dev/null 2>&1; then
  PYTHON_CMD=(python)
elif command -v python3 >/dev/null 2>&1; then
  PYTHON_CMD=(python3)
elif command -v py >/dev/null 2>&1; then
  PYTHON_CMD=(py -3)
else
  echo "Python is required to parse the project tree." >&2
  exit 1
fi

"${PYTHON_CMD[@]}" - "$TREE_FILE" <<'PY'
from pathlib import Path
import re
import sys

base_dir = Path.cwd()
tree_file = Path(sys.argv[1])

try:
    lines = [line.rstrip("\n") for line in tree_file.read_text(encoding="utf-8").splitlines() if line.strip()]
except FileNotFoundError:
    raise SystemExit(f"Tree file not found: {tree_file}")

if not lines:
    raise SystemExit("Tree file is empty.")

# Ignore the project root label, if present, such as: "rag-chatbot/"
if lines[0].rstrip().endswith("/"):
    lines = lines[1:]

stack: list[str] = []

for raw in lines:
    # Strip the tree drawing from the start of the line, keeping only the actual name.
    stripped = re.sub(r"^(?:[│├└─\s]+)", "", raw).strip()
    if not stripped:
        continue

    is_dir = stripped.endswith("/")
    name = stripped[:-1] if is_dir else stripped
    if not name:
        continue

    # Count only the spaces left in the tree prefix. This maps the visual indentation
    # into a reasonable nesting depth for the generated file system tree.
    prefix = raw[: raw.find(name)] if name in raw else ""
    spaces = len(prefix.replace("│", "").replace("├", "").replace("└", "").replace("─", ""))
    depth = max(0, (spaces + 1) // 4)

    while len(stack) > depth:
        stack.pop()

    target = base_dir.joinpath(*stack, name)

    if is_dir:
        target.mkdir(parents=True, exist_ok=True)
        stack.append(name)
    else:
        target.parent.mkdir(parents=True, exist_ok=True)
        target.touch(exist_ok=True)

print(f"Created project structure under {base_dir}")
PY

echo "Done."