{ config, pkgs, lib, ... }:

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

  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  programs.bat.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
  programs.git = {
    enable = true;
    userName = "Graham Bennett";
    userEmail = "graham@grahambennett.org";
    extraConfig = {
      pull = { rebase = "true"; };
      push = { default = "simple"; };
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
  programs.i3status = {
    enable = true;
    modules = {
      "volume master" = {
        position = 1;
        settings = {
          format = "♪ %volume";
          format_muted = "♪ muted (%volume)";
          device = "pulse:1";
        };
      };
    };
  };
  programs.jq.enable = true;
  programs.ssh = {
    enable = true;
    serverAliveInterval = 300;
    serverAliveCountMax = 2;
  };
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 100000;
    keyMode = "vi";
    prefix = "C-o";
    terminal = "screen-256color";
  };
  programs.vim = {
    enable = true;
    settings = {
      background = "dark";
    };
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

  services.dropbox = {
    enable = true;
  };
  services.emacs = {
    enable = true;
    client = {
      enable = true;
    };
    defaultEditor = true;
  };
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
  };

  # spacemacs
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
  home.file.".spacemacs".source = ./spacemacs;

  home.packages = let
    graham33-scripts = pkgs.stdenv.mkDerivation {
      name = "graham33-scripts";
      src = pkgs.fetchgit {
        url = "https://github.com/graham33/scripts";
        rev = "8808769ce17fe747d80f73d802dd3ade147a38b8";
        sha256 = "099nsij8s4cawlid08v8mg5iqyb9ikdg546cdm4d8p1g1d9y8jja";
      };
      buildCommand = ''
      mkdir -p $out/bin
      cp $src/* $out/bin
    ''   ;
    };
    myPython3 = pkgs.python3.withPackages (ps: with ps; [
      boto3
      click
      numpy
      pandas
      pip
      pytest
      pyyaml
      wheel
      yapf
    ]);
  in with pkgs; [
    awscli
    cachix
    gdb
    gimp
    gnome.nautilus
    gnuplot
    google-chrome
    git-crypt
    gnumake
    graham33-scripts
    libreoffice
    lxterminal
    mpv
    myPython3
    nix-prefetch-git
    nixpkgs-review
    nmap
    pavucontrol
    pstree
    remmina
    ripgrep
    socat
    sxiv
    traceroute
    unzip
    vlc
    wally-cli
    websocat
    wget
    whois
    yarn2nix
    zoom-us
  ];

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      defaultWorkspace = "workspace number 1";
      fonts = {
        names = [ "Source Code Pro" ];
        size = 11.0;
      };
      keybindings = let
        modifier = config.xsession.windowManager.i3.config.modifier;
        refresh_i3status = "killall -SIGUSR1 i3status";
      in lib.mkOptionDefault {
        "${modifier}+Shift+j" = "move left";
        "${modifier}+Shift+k" = "move down";
        "${modifier}+Shift+l" = "move up";
        "${modifier}+Shift+semicolon" = "move right";
        # Use pactl to adjust volume in PulseAudio.
        XF86AudioRaiseVolume = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && ${refresh_i3status}";
        XF86AudioLowerVolume = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && ${refresh_i3status}";
        XF86AudioMute = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && ${refresh_i3status}";
        XF86AudioMicMute = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && ${refresh_i3status}";
        # Screen brightness controls
        XF86MonBrightnessUp = "exec xbright +0.1 # increase screen brightness";
        XF86MonBrightnessDown = "exec xbright -0.1 # decrease screen brightness";
        # Toggle displays
        XF86Display = "exec --no-startup-id toggle-display eDP-1";
      };
      modifier = "Mod4";
      startup = [
        { command = "${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- i3lock --nofork"; notification = false; }
        { command = "nm-applet"; notification = false; }
        { command = "dropbox start"; notification = false; }
        # screensaver after 20 mins
        { command = "xset s 1200"; }
        # screen standby after 30 mins, turn off after 1hr
        { command = "xset dpms 1800 1800 3600
"; }
      ];
      terminal = "lxterminal";
    };
  };

  home.file.".octaverc".source = ./octaverc;
  xdg.configFile."lxterminal/lxterminal.conf".source = ./config/lxterminal/lxterminal.conf;
  xdg.configFile."vlc/vlcrc".source = ./config/vlc/vlcrc;
  xdg.configFile."zoomus.conf".source = ./config/zoomus.conf;

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
