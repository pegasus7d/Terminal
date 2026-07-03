# Terminal Dotfiles

> Portable terminal setup for macOS — managed with **Nix home-manager** + **Homebrew**.

---

## What's Inside

| File / Folder | Purpose |
|---|---|
| `flake.nix` | Nix flake — pins all inputs (nixpkgs-unstable + home-manager) |
| `home.nix` | Home Manager config — installs tools, writes dotfiles |
| `Brewfile` | Homebrew — GUI apps & things Nix handles poorly on macOS |
| `config/ghostty/` | Ghostty terminal config |
| `config/p10k.zsh` | Powerlevel10k prompt theme |
| `config/nano/nanorc` | Nano editor config |
| `config/yazi/` | Yazi file manager + smart-enter plugin |

### Tools managed by Nix

- **Shell:** zsh · oh-my-zsh · Powerlevel10k · autosuggestions · syntax highlighting · zoxide
- **File tools:** yazi · eza · bat · fzf
- **Git:** git · delta (diff pager)
- **Editor:** nano (custom config)
- **Other:** scooter, ripgrep, fd, and more

### Managed by Homebrew (`Brewfile`)

- **Ghostty** — terminal emulator
- **JetBrains Mono Nerd Font** — icons + ligatures
- **scooter** — search & replace TUI

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

### 4. Apply Nix config

Installs all CLI tools and symlinks dotfiles into place:

```sh
nix run home-manager/master -- switch --flake ~/dotfiles#debayan
```

> On Apple Silicon this works out of the box. For Intel Mac, change `aarch64-darwin` → `x86_64-darwin` in `flake.nix` first.

### 5. Apply Brewfile

Installs Ghostty, the Nerd Font, and scooter:

```sh
brew bundle --file=~/dotfiles/Brewfile
```

### 6. Add machine-local secrets

Create `~/.zshrc.local` (git-ignored and auto-sourced by the managed `.zshrc`):

```sh
export OPENAI_API_KEY=...
export GITHUB_PAT=...
# machine-specific PATH tweaks, conda init, etc.
```

Open a new terminal — done.

---

## Updating

After editing any config file in this repo:

```sh
home-manager switch --flake ~/dotfiles#debayan
```

---

## Notes

- Secrets are **never** committed. Everything sensitive goes in `~/.zshrc.local`.
- The flake is pinned to `nixpkgs-unstable` — run `nix flake update` to pull latest packages.
- This config targets **Apple Silicon** (`aarch64-darwin`). Intel users change the system string in `flake.nix`.
