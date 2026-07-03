# Terminal Dotfiles

> Portable terminal setup for macOS — managed with **Nix home-manager** + **Homebrew**.  
> Targets Apple Silicon (`aarch64-darwin`). Reproducible, declarative, no manual steps.

---

## What's Inside

```
dotfiles/
├── flake.nix               # Nix flake — pins nixpkgs-unstable + home-manager
├── flake.lock              # Locked dependency versions
├── home.nix                # Home Manager — installs tools + writes all dotfiles
├── Brewfile                # Homebrew — GUI apps Nix handles poorly on macOS
└── config/
    ├── ghostty/config      # Ghostty terminal (theme, font, keybinds)
    ├── p10k.zsh            # Powerlevel10k two-line prompt config
    ├── nano/nanorc         # Nano with syntax highlighting
    └── yazi/
        └── plugins/
            └── smart-enter.yazi/   # Enter dir or open file with one key
```

---

## Tools

### Shell
| Tool | Role |
|---|---|
| zsh + oh-my-zsh | Shell with plugins: `git`, `web-search`, `jsontools`, `macos` |
| Powerlevel10k | Two-line prompt with git status, timing, exit codes |
| zsh-autosuggestions | Fish-style inline suggestions |
| zsh-syntax-highlighting | Real-time command coloring |
| zoxide | Smarter `cd` — jump to frecent dirs with `z` |
| fzf | Fuzzy finder (`Ctrl+T` files, `Ctrl+R` history) |

### File & Search
| Tool | Role |
|---|---|
| yazi | TUI file manager (launches with `y`, exits back to that dir) |
| eza | Modern `ls` with icons, git status, tree view |
| bat | `cat` with syntax highlighting and line numbers |
| ripgrep (`rg`) | Fast recursive grep |
| fd | Fast `find` alternative |

### Git
| Tool | Role |
|---|---|
| git | Version control |
| delta | Diff pager — side-by-side, line numbers, navigate mode |
| lazygit | TUI git client |
| gh | GitHub CLI |

### Other
| Tool | Role |
|---|---|
| btop | Resource monitor |
| dust | Disk usage visualizer (`du` replacement) |
| duf | Disk free space overview |
| tealdeer (`tldr`) | Concise command examples |
| jq | JSON processor |
| nano | Editor with syntax highlighting + mouse support |
| pass | Password manager |
| doppler | Secrets manager CLI |
| scooter | Search & replace TUI |

### Via Homebrew (`Brewfile`)
| Tool | Role |
|---|---|
| Ghostty | GPU-accelerated terminal emulator |
| JetBrains Mono Nerd Font | Font with icons + ligatures |
| scooter | Search & replace TUI |

---

## Shell Aliases

```zsh
ls  → eza --icons --group-directories-first
ll  → eza -l --icons --group-directories-first --git
la  → eza -la --icons --group-directories-first --git
lt  → eza --tree --icons --level=2
cat → bat
vi  → nano
vim → nano
```

---

## Shell Functions

```zsh
ff [query]   # Fuzzy-find a file and open it in $EDITOR
fif <term>   # Find-in-files with ripgrep → fzf preview → open in $EDITOR
```

---

## Ghostty Config Highlights

| Setting | Value |
|---|---|
| Theme | Rose Pine Moon |
| Font | JetBrains Mono Nerd Font Mono, 15pt |
| Background | 92% opacity + blur radius 20 (frosted glass) |
| Cursor | Blinking block |
| Quick terminal | `Cmd+`` ` — global drop-down from anywhere |
| File sidebar | `Cmd+E` — opens a left split (type `y` to launch Yazi) |

---

## Setup on a New Mac

### 1. Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install Nix (Determinate installer)

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 3. Clone this repo

```sh
git clone git@github.com:pegasus7d/Terminal.git ~/dotfiles
```

### 4. Update username in `home.nix`

Open `home.nix` and set your actual macOS username:

```nix
home.username = "your-username";
home.homeDirectory = "/Users/your-username";
```

### 5. Apply Nix config

Installs all CLI tools and symlinks dotfiles into place:

```sh
nix run home-manager/master -- switch --flake ~/dotfiles#debayan -b backup
```

> The `-b backup` flag moves any conflicting existing dotfiles to `.backup` instead of aborting.  
> For Intel Mac, change `aarch64-darwin` → `x86_64-darwin` in `flake.nix` first.

### 6. Apply Brewfile

```sh
brew bundle --file=~/dotfiles/Brewfile
```

### 7. Add machine-local secrets

Create `~/.zshrc.local` (git-ignored, auto-sourced by `.zshrc`):

```sh
export OPENAI_API_KEY=...
export GITHUB_PAT=...
# machine-specific PATH tweaks, conda init, nvm, etc.
```

Open a new terminal — done.

---

## Updating

After changing any config in this repo:

```sh
home-manager switch --flake ~/dotfiles#debayan
```

To pull latest packages from nixpkgs-unstable:

```sh
nix flake update && home-manager switch --flake ~/dotfiles#debayan
```

---

## Notes

- **Secrets are never committed.** Everything sensitive lives in `~/.zshrc.local`.
- The flake is pinned to `nixpkgs-unstable` for cutting-edge packages. Use `nix flake update` to refresh.
- This config is built for **Apple Silicon**. Intel users set `system = "x86_64-darwin"` in `flake.nix`.
- The home-manager profile name is `debayan` — change it in `flake.nix` if you want a different name.
