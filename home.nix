{ config, pkgs, lib, cudaSupport, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  fonts.fontconfig.enable = true;

  programs.awscli = {
    enable = true;
  };
  programs.bat.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-git;
  };
  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
    tmux.shellIntegrationOptions = ["-p80%,60%"];
  };
  programs.git = {
    enable = true;
    extraConfig = {
      pull = {
        rebase = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
    };
  };
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };
  programs.gpg = {
    enable = true;
  };
  programs.htop.enable = true;
  programs.jq.enable = true;
  programs.ssh = {
    enable = true;
    serverAliveInterval = 300;
    serverAliveCountMax = 2;
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      aws = {
        disabled = true;
      };
    };
  };
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    historyLimit = 100000;
    keyMode = "vi";
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = tmux-colors-solarized;
        extraConfig = ''
          set -g @colors-solarized 'dark'
        '';
      }
    ];
    prefix = "C-o";
    terminal = "tmux-256color";
  };
  programs.vim = {
    enable = true;
    settings = {
      background = "dark";
    };
  };
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    initExtra = ''
      # Work around problem with env init clobbering EDITOR
      export EDITOR="emacsclient -nw -c"
      export PATH="$PATH:$HOME/.config/emacs/bin"
      # 1Password plugins
      source ~/.op/plugins.sh
    '';
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs-git;
    client = {
      enable = true;
    };
    socketActivation.enable = true;
    startWithUserSession = "graphical";
  };

  home.packages = let
    myPython3 = pkgs.python3.withPackages (ps: with ps; [
      boto3
      click
      isort
      numpy
      pandas
      pip
      pytest
      python-lsp-server
      pyyaml
      rope
      wheel
      yapf
    ]);
  in with pkgs; [
    cachix
    coreutils
    fd
    fira-code-nerdfont
    freerdp
    gdb
    gnuplot
    git-crypt
    gnumake
    imagemagick
    killall
    markdownlint-cli2
    mdl
    myPython3
    nix
    nix-output-monitor
    nix-prefetch-git
    nixfmt
    nixpkgs-review
    nmap
    pstree
    ripgrep
    rubber
    shellcheck
    socat
    traceroute
    unzip
    waypipe
    websocat
    wget
    whois
    yarn2nix
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient -nw -c";
  };

  home.shellAliases = {
    e = "emacsclient -nw -c";
  };

  systemd.user.sessionVariables = {
    # So the emacs service has the right terminal colours
    COLORTERM = "truecolor";
    TERM = "xterm-256color";
  };

  # Let home-manager automatically start systemd user services.
  # Will eventually become the new default.
  systemd.user.startServices = "sd-switch";

  home.file.".octaverc".source = ./octaverc;
  home.file.".op/plugins.sh".source = ./op/plugins.sh;
  xdg.configFile."doom/config.el".source = ./config/doom/config.el;
  xdg.configFile."doom/init.el".source = ./config/doom/init.el;
  xdg.configFile."doom/packages.el".source = ./config/doom/packages.el;
  xdg.configFile."hypr/hypridle.conf".source = ./config/hypr/hypridle.conf;
  xdg.configFile."hypr/hyprlock.conf".source = ./config/hypr/hyprlock.conf;
  xdg.configFile."vlc/vlcrc".source = ./config/vlc/vlcrc;
  xdg.configFile."zoomus.conf".source = ./config/zoomus.conf;

  home.activation = {
    syncDoomEmacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
      doom sync
    '';
  };
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
