# Project Tree Generator

This repository contains two Bash-based utilities that recreate a project directory structure from a text-based tree definition.

They are useful when you want to scaffold a project layout from a simple tree diagram, share a folder structure in version control, or quickly generate the same structure on another machine.

## Why this exists

This repository includes a project tree definition in [project_tree.txt](project_tree.txt). The scripts read that file and create the matching folders and empty files in any target directory.

## Features

- Reads a tree file such as a GitHub-style directory listing
- Creates directories and empty files automatically
- Supports custom input and output paths
- Works from Git Bash on Windows and standard Bash environments

## Scripts included

- [build_project_tree.sh](build_project_tree.sh) — recommended Bash-only version; no Python required
- [generate_project_tree.sh](generate_project_tree.sh) — Python-backed alternative
- [project_tree.txt](project_tree.txt) — default tree definition used by both scripts

## Requirements

### Bash-only script

- No Python required
- Works with Bash on Windows, macOS, and Linux

### Python-backed script

- Python 3 installed and available on your PATH

Check it with:

```bash
python --version
```

or:

```bash
python3 --version
```

If Python is not installed, use the Bash-only script instead.

## Quick Start

### Recommended: Bash-only version

From the repository root:

```bash
bash ./build_project_tree.sh
```

This uses [project_tree.txt](project_tree.txt) as the default input and creates the folder structure in the current directory.

Create the structure in a custom folder:

```bash
bash ./build_project_tree.sh project_tree.txt ./output-folder
```

Use a different tree file:

```bash
bash ./build_project_tree.sh my_tree.txt ./output-folder
```

Show the help text:

```bash
bash ./build_project_tree.sh --help
```

### Python version

```bash
bash ./generate_project_tree.sh
```

or:

```bash
bash ./generate_project_tree.sh project_tree.txt ./output-folder
```

## Example

The default tree file defines a structure similar to:

```text
rag-chatbot/
├── docker-compose.yml
├── entrypoint.sh
├── server/
│   ├── Dockerfile
│   ├── package.json
│   ├── tsconfig.json
│   └── src/
│       ├── config/
│       │   └── environment.ts
│       ├── db/
│       │   └── sqliteStore.ts
│       ├── embeddings/
│       │   └── ollama.ts
│       ├── services/
│       │   ├── cleanupWorker.ts
│       │   └── parentIngestion.ts
│       ├── workflow/
│       │   ├── state.ts
│       │   ├── nodes.ts
│       │   └── graph.ts
│       └── server.ts
└── client/
    ├── Dockerfile
    ├── package.json
    ├── tsconfig.json
    ├── index.html
    └── src/
        ├── App.tsx
        ├── main.tsx
        └── index.css
```

The script creates matching directories and empty files in the output directory.

## Notes

- The script is intended for scaffolding or quick project setup.
- It creates empty files, not full file contents.
- It is best suited for generating a folder skeleton rather than a complete working app.

## License

This project is provided as-is for personal and educational use.
