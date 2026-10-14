# Project Tree Generator

A small Bash utility that recreates a project directory structure from a text-based tree definition.

This is useful when you want to scaffold a project layout from a simple tree diagram, share it in version control, or quickly generate the same structure on another machine.

## Why this exists

This repository includes a project tree definition in [project_tree.txt](project_tree.txt). The script reads that file and creates the matching folders and empty files in any target directory.

## Features

- Reads a tree file such as a GitHub-style directory listing
- Creates directories and empty files automatically
- Supports custom input and output paths
- Works from Git Bash on Windows and standard Bash environments

## Requirements

- Python 3 installed and available on your PATH

Check it with:

```bash
python --version
```

or:

```bash
python3 --version
```

If Python is not installed, install it first and then run the script.

## Script

- [generate_project_tree.sh](generate_project_tree.sh)
- [project_tree.txt](project_tree.txt)

## Quick Start

From the repository root:

```bash
bash ./generate_project_tree.sh
```

This uses [project_tree.txt](project_tree.txt) as the default input and creates the folder structure in the current directory.

Create the structure in a custom folder:

```bash
bash ./generate_project_tree.sh project_tree.txt ./output-folder
```

Use a different tree file:

```bash
bash ./generate_project_tree.sh my_tree.txt ./output-folder
```

Show the help text:

```bash
bash ./generate_project_tree.sh --help
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
