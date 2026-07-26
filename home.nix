{ config, pkgs, lib, ... }:

{
  home.username = "debayanbiswas";
  home.homeDirectory = "/Users/debayanbiswas";
  home.stateVersion = "24.11";

  # Let home-manager manage itself.
  programs.home-manager.enable = true;

  # ---------------------------------------------------------------------------
  # CLI tools (pinned & reproducible). GUI apps + fonts + scooter → Brewfile.
  # ---------------------------------------------------------------------------
  home.packages = with pkgs; [
    ripgrep       # rg
    fd
    jq
    stow
    pass
    gh
    doppler
    btop
    dust          # du-dust (renamed)
    duf
    tealdeer      # tldr
    nano          # GNU nano (with syntax files)
  ];

  # ---------------------------------------------------------------------------
  # Programs with home-manager modules (installs binary + manages config)
  # ---------------------------------------------------------------------------
  programs.bat.enable = true;
  programs.eza.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.lazygit.enable = true;

  programs.git = {
    enable = true;
    settings = {
      core.editor = "nano";
      merge.conflictStyle = "zdiff3";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
    };
  };

  # Yazi — file manager, with the smart-enter plugin + our settings/keymap
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings = {
      mgr = {
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
        mouse_events = [ "click" "scroll" ];
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        { on = "<Enter>"; run = "plugin smart-enter"; desc = "Enter the folder, or open the file"; }
      ];
    };
    plugins = {
      smart-enter = ./config/yazi/plugins/smart-enter.yazi;
    };
  };

  # ---------------------------------------------------------------------------
  # Zsh — oh-my-zsh + powerlevel10k + autosuggestions + syntax highlighting
  # ---------------------------------------------------------------------------
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "web-search" "jsontools" "macos" "brew" ];
    };

    shellAliases = {
      vi = "nano";
      vim = "nano";
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first --git";
      la = "eza -la --icons --group-directories-first --git";
      lt = "eza --tree --icons --level=2";
      cat = "bat";
      cc = "claude";
    };

    sessionVariables = {
      EDITOR = "nano";
      VISUAL = "nano";
      FZF_DEFAULT_COMMAND = "fd --type f --hidden --strip-cwd-prefix --exclude .git";
      FZF_DEFAULT_OPTS = "--height=80% --layout=reverse --border=rounded --info=inline --preview 'bat --color=always --style=numbers --line-range=:300 {}' --preview-window=right:60%:wrap --color=bg+:#2a273f,fg+:#e0def4,hl:#ea9a97,hl+:#ea9a97,border:#403d52,info:#9ccfd8";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initExtra = ''
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"

      # p10k prompt config (deployed by this flake)
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # ff = fuzzy-find a file and open it in $EDITOR
      ff() {
        local f
        f=$(fzf --query="''${1:-}") && [ -n "$f" ] && ''${EDITOR:-nano} "$f"
      }

      # fif = find-in-files (ripgrep -> fzf -> open)
      fif() {
        local f
        f=$(rg --line-number --no-heading --color=never "''${1:-}" 2>/dev/null \
            | fzf --delimiter=: --preview 'bat --color=always --style=numbers --highlight-line={2} {1}' \
                  --preview-window='right:60%:+{2}-5')
        [ -n "$f" ] && ''${EDITOR:-nano} "''${f%%:*}"
      }

      # Machine-specific config + SECRETS live here (git-ignored, never committed).
      [ -f ~/.zshrc.local ] && source ~/.zshrc.local
    '';
  };

  # ---------------------------------------------------------------------------
  # Dotfiles deployed as-is
  # ---------------------------------------------------------------------------
  # Ghostty terminal config
  xdg.configFile."ghostty/config".source = ./config/ghostty/config;

  # p10k prompt (your tuned two-line/transient config)
  home.file.".p10k.zsh".source = ./config/p10k.zsh;

  # nano syntax highlighting — points at the Nix-installed nano's syntax files (portable)
  home.file.".nanorc".text = ''
    include "${pkgs.nano}/share/nano/*.nanorc"
    set linenumbers
    set mouse
    set softwrap
    set tabsize 4
    set autoindent
    set constantshow
    set indicator
    set titlecolor    brightwhite,blue
    set numbercolor   cyan
    set statuscolor   brightwhite,green
    set keycolor      brightcyan
    set functioncolor green
    set stripecolor   ,brightblack
    set selectedcolor brightwhite,magenta
  '';
}
