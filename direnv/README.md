# Direnv Configuration

Modern, modular direnv configuration with reusable helper functions, templates, and CLI tools for managing `.envrc` files across multiple projects.

## Features

- **Modular Library**: Organized helper functions for common tasks
- **Template System**: Quick-start templates for Python, Node.js, Go, Rust, and Nix
- **CLI Tools**: `envrc-init` for generating `.envrc` files, `envrc-validate` for validation
- **Backward Compatible**: Existing configurations continue to work
- **Extensible**: Easy to add new layouts and helpers

## Structure

```
direnv/
├── .config/
│   └── direnv/
│       ├── direnvrc              # Main config (sources lib/)
│       ├── lib/
│       │   ├── layouts.sh        # Layout functions
│       │   ├── utils.sh          # Utility functions
│       │   └── nix.sh            # Nix helpers
│       ├── templates/
│       │   ├── python-uv.envrc
│       │   ├── python-poetry.envrc
│       │   ├── python.envrc
│       │   ├── node.envrc
│       │   ├── go.envrc
│       │   ├── rust.envrc
│       │   ├── nix-flake.envrc
│       │   ├── nix-shell.envrc
│       │   └── multi-lang.envrc
│       └── bin/
│           ├── envrc-init        # Template generator
│           └── envrc-validate    # Validator
└── README.md                     # This file
```

## Installation

The direnv configuration uses a hybrid approach: executable scripts are managed by home-manager, while configuration files are managed by stow.

### With nix-darwin (Recommended)

```bash
cd ~/projects/oss/dot-files
darwin-rebuild switch --flake .#darwin-system
```

This will:
- Install executable scripts to `~/.local/bin/` via home-manager
- Install direnv configuration via stow (automatically run by the flake's shellHook)

### Verify Installation

After running `darwin-rebuild switch`, verify the installation:

```bash
# Check if scripts are accessible
which envrc-init
which envrc-validate

# Should show: /Users/yourusername/.local/bin/envrc-init

# Check if direnv config exists
ls ~/.config/direnv/

# List available templates
envrc-init --list
```

### What Gets Installed

**Via home-manager** (`home.nix`):
- `~/.local/bin/envrc-init` - Template generator
- `~/.local/bin/envrc-validate` - Validator

**Via stow** (run by flake shellHook):
- `~/.config/direnv/direnvrc` - Main configuration
- `~/.config/direnv/lib/*.sh` - Helper libraries
- `~/.config/direnv/templates/*.envrc` - Templates

This hybrid approach works because:
- Executables in `~/.local/bin/` need to be managed by home-manager for proper PATH integration
- Direnv configuration files can be sourced from anywhere, so stow works fine

## Quick Start

### Auto-detect and Create .envrc

Navigate to your project and run:

```bash
envrc-init
```

This will automatically detect your project type and create an appropriate `.envrc` file.

### Use a Specific Template

```bash
envrc-init --template python-uv
```

### List Available Templates

```bash
envrc-init --list
```

### Validate .envrc

```bash
envrc-validate
```

## Available Layouts

### Python with uv

```bash
layout uv
```

Automatically:
- Detects `pyproject.toml`
- Creates `.venv` if it doesn't exist
- Activates virtual environment
- Adds annotation to prompt

### Python with Poetry

```bash
layout poetry
```

Automatically:
- Detects `pyproject.toml` and `poetry.lock`
- Uses Poetry's virtual environment
- Activates environment
- Adds annotation to prompt

### Python with venv

```bash
layout python
```

Generic Python virtual environment support.

### Node.js

```bash
layout node
```

Automatically:
- Detects `package.json`
- Adds `node_modules/.bin` to PATH
- Detects package manager (npm, yarn, pnpm, bun)
- Sets `NODE_ENV=development`

### Go

```bash
layout go
```

Automatically:
- Detects `go.mod`
- Adds `./bin` to PATH
- Sets `GOPATH` and `GOBIN`
- Extracts module name

### Rust

```bash
layout rust
```

Automatically:
- Detects `Cargo.toml`
- Adds `target/debug` and `target/release` to PATH
- Extracts package name

## Utility Functions

### env_var

Safely set environment variables with validation:

```bash
env_var "API_KEY" "$API_KEY" true  # Required
env_var "DEBUG" "true" false       # Optional
```

### path_add

Add directories to PATH with deduplication:

```bash
path_add "$HOME/.local/bin"
```

### load_env_file

Load environment variables from a file:

```bash
load_env_file .env
load_env_file .env.local
```

### detect_project_type

Detect the project type:

```bash
project_type=$(detect_project_type)
echo "Project type: $project_type"
```

### ensure_command

Check if a command is available:

```bash
ensure_command "uv" "curl -LsSf https://astral.sh/uv/install.sh | sh"
```

## Nix Helpers

### layout_flake

Enhanced flake loading with automatic file watching:

```bash
layout_flake
layout_flake ./path/to/flake
```

This is a wrapper around `use flake` that adds automatic file watching and annotations. For most cases, just use the built-in `use flake` command directly.

### layout_nix_shell

Load nix-shell environments with automatic file watching:

```bash
layout_nix_shell
layout_nix_shell shell.nix
```

This is a wrapper around `use nix` that adds automatic file watching and annotations. For most cases, just use the built-in `use nix` command directly.

### layout_nix_auto

Auto-detect and use Nix (flake or shell):

```bash
layout_nix_auto
```

Automatically detects whether to use `layout_flake` or `layout_nix_shell` based on which files are present.

## Templates

### Python with uv

```bash
layout uv
```

Optional: Add `watch_file` for dependencies:
```bash
watch_file pyproject.toml
watch_file uv.lock
```

### Python with Poetry

```bash
layout poetry
```

Optional: Add `watch_file` for dependencies:
```bash
watch_file pyproject.toml
watch_file poetry.lock
```

### Node.js

```bash
layout node
```

Optional: Add `watch_file` for dependencies:
```bash
watch_file package.json
watch_file package-lock.json
```

### Go

```bash
layout go
```

Optional: Add `watch_file` for dependencies:
```bash
watch_file go.mod
watch_file go.sum
```

### Rust

```bash
layout rust
```

Optional: Add `watch_file` for dependencies:
```bash
watch_file Cargo.toml
watch_file Cargo.lock
```

### Nix Flake

```bash
use flake
```

Note: `use flake` automatically watches `flake.nix` and `flake.lock` when using nix-direnv.

### Multi-language

```bash
use flake

layout node
```

## CLI Tools

### envrc-init

Generate `.envrc` files from templates.

**Usage:**

```bash
envrc-init [OPTIONS]
```

**Options:**

- `-h, --help` - Show help message
- `-l, --list` - List available templates
- `-t, --template NAME` - Use specific template
- `-c, --custom CONTENT` - Create with custom content
- `-f, --force` - Overwrite existing `.envrc`
- `-a, --auto` - Auto-detect project type (default)

**Examples:**

```bash
# Auto-detect and create
envrc-init

# Use specific template
envrc-init --template python-uv

# Custom content
envrc-init --custom "layout uv; export DEBUG=1"

# Force overwrite
envrc-init --template node --force

# List templates
envrc-init --list
```

### envrc-validate

Validate `.envrc` syntax and configuration.

**Usage:**

```bash
envrc-validate [FILE]
```

**What it checks:**

- Bash syntax errors
- Common layout/use directives
- watch_file directives
- Dangerous patterns (rm -rf, sudo, curl | bash)
- Environment loading (dry-run)

**Examples:**

```bash
# Validate current directory
envrc-validate

# Validate specific file
envrc-validate .envrc

# Validate parent directory
envrc-validate ../.envrc
```

## Migration Guide

### From Existing Setup

If you have an existing `.envrc` file, it will continue to work. The new library functions are backward compatible.

### Updating Existing .envrc Files

1. Check your current `.envrc`:

```bash
cat .envrc
```

2. Validate it:

```bash
envrc-validate
```

3. If you want to use the new templates:

```bash
# Backup existing
mv .envrc .envrc.backup

# Create new from template
envrc-init --template python-uv

# Compare and merge if needed
diff .envrc.backup .envrc
```

### Custom Functions

If you have custom functions in your old `direnvrc`, you can:

1. Add them to `~/.config/direnv/lib/custom.sh`
2. They will be automatically sourced

## Examples

### Python Project with uv

```bash
cd my-python-project
envrc-init --template python-uv
direnv allow
```

Your `.envrc`:

```bash
layout uv

watch_file pyproject.toml
watch_file uv.lock
```

### Node.js Project

```bash
cd my-node-project
envrc-init --template node
direnv allow
```

Your `.envrc`:

```bash
layout node

watch_file package.json
watch_file package-lock.json
```

### Multi-language Project (Nix + Node)

```bash
cd my-fullstack-project
envrc-init --template multi-lang
direnv allow
```

Your `.envrc`:

```bash
use flake

layout node

watch_file flake.nix
watch_file flake.lock
watch_file package.json
```

### Custom Configuration

```bash
cd my-custom-project
cat > .envrc <<EOF
use flake

layout uv

export DEBUG=1
export API_URL="http://localhost:8000"

load_env_file .env.local

watch_file flake.nix
watch_file pyproject.toml
watch_file .env.local
EOF

direnv allow
```

## Best Practices

1. **Always use watch_file**: This ensures direnv reloads when dependencies change

```bash
watch_file pyproject.toml
watch_file requirements.txt
```

2. **Load environment files**: Keep secrets in `.env` files (add to `.gitignore`)

```bash
load_env_file .env
load_env_file .env.local
```

3. **Validate before allowing**: Always validate your `.envrc` before allowing

```bash
envrc-validate
direnv allow
```

4. **Use annotations**: The layouts automatically add annotations to your prompt

```bash
# Your prompt will show: (+ uv my-project)
```

5. **Combine layouts**: You can use multiple layouts in one `.envrc`

```bash
use flake
layout node
layout uv  # If you have both Node and Python
```

## Troubleshooting

### direnv not loading

```bash
# Check if direnv is installed
which direnv

# Check if .envrc is allowed
direnv status

# Allow the .envrc
direnv allow
```

### Layout function not found

```bash
# Check if direnvrc is sourcing the library
cat ~/.config/direnv/direnvrc

# Should contain:
# source ~/.config/direnv/lib/layouts.sh
```

### Virtual environment not activating

```bash
# For Python/uv
uv venv

# For Poetry
poetry install

# Then reload direnv
direnv reload
```

### envrc-init not found

```bash
# Check if bin directory is in PATH
echo $PATH | grep direnv

# Add to ~/.zshrc or ~/.bashrc
export PATH="$HOME/.config/direnv/bin:$PATH"

# Reload shell
source ~/.zshrc
```

## Contributing

To add new layouts or utilities:

1. Add functions to appropriate library file:
   - `lib/layouts.sh` - Layout functions
   - `lib/utils.sh` - Utility functions
   - `lib/nix.sh` - Nix helpers

2. Create a template in `templates/`

3. Update this README

## Resources

- [direnv documentation](https://direnv.net/)
- [nix-direnv](https://github.com/nix-community/nix-direnv)
- [uv documentation](https://docs.astral.sh/uv/)
- [Poetry documentation](https://python-poetry.org/)

## License

Part of the dotfiles repository. See main repository for license information.
