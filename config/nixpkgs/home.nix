{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "graham";
  home.homeDirectory = "/home/graham";

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://cache.nixos.org/"
        "https://graham33.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "graham33.cachix.org-1:DqH72VpwSrACa3+L9eqh4bixjWx9IQUaxQtRh4gtkX8="
      ];
    };
  };

  programs.bat.enable = true;
  programs.git = {
    enable = true;
    userName = "Graham Bennett";
    userEmail = "graham@grahambennett.org";
    extraConfig = {
      pull = { rebase = "true"; };
      push = { default = "simple"; };
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
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
  programs.htop.enable = true;
  programs.jq.enable = true;
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 100000;
    keyMode = "vi";
    prefix = "C-o";
    terminal = "screen-256color";
  };
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "direnv"
        "git"
        "vi-mode"
      ];
      theme = "robbyrussell";
    };
    plugins = [
      {
        name = "nix-shell";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "sha256-IT3wpfw8zhiNQsrw59lbSWYh0NQ1CUdUtFzRzHlURH0=";
        };
      }
    ];
  };

  services.emacs = {
    enable = true;
    client = {
      enable = true;
    };
    defaultEditor = true;
  };

  # TODO: .spacemacs
  home.file.".emacs.d" = {
    # don't make the directory read only so that impure melpa can still happen
    # for now
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "syl20bnr";
      repo = "spacemacs";
      rev = "4688cd7dcea36ee346d1aafba7f0638f4d816c28";
      sha256 = "sha256-M5xr4pRpiKbyg68oADrCHGLdiB3cFnzkmh9WHFTI/Mw=";
    };
  };

  home.packages = with pkgs; [
    gdb
    gnumake
    ripgrep
  ];

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
