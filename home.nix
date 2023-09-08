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
  programs.emacs = {
    enable = true;
    package = pkgs.emacsGit;
  };
  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
  };
  programs.git = {
    enable = true;
    userName = "Graham Bennett";
    userEmail = "graham@grahambennett.org";
    extraConfig = {
      pull = {
        rebase = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      safe = {
        directory = "/nix/store/9ijxm2d0vl4jrv8yl25yw67palhf1mk6-airflow";
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
  programs.i3status = {
    enable = true;
    modules = {
      "volume master" = {
        position = 1;
        settings = {
          device = "pulse";
        };
      };
    };
  };
  programs.jq.enable = true;
  programs.kitty = {
    enable = true;
    extraConfig = ''
      enable_audio_bell no
    '';
    font = {
      name = "Source Code Pro";
      size = 14;
    };
    theme = "Solarized Dark";
  };
  programs.ssh = {
    enable = true;
    serverAliveInterval = 300;
    serverAliveCountMax = 2;
  };
  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      inherit (tpkgs) catchfile crossword lastpage newlfm patchcmd scheme-small svg titling transparent trimspaces;
    };
  };
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    extraConfig = ''
      set -g mouse on
    '';
    historyLimit = 100000;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];
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
    initExtra = ''
      # Work around problem with env init clobbering EDITOR
      export EDITOR="emacsclient -nw -c"
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "direnv"
        "git"
        "vi-mode"
      ];
      theme = "agnoster";
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
    package = pkgs.emacsGit;
    client = {
      enable = true;
    };
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
      rev = "e4b20f797d9e7a03d9a5603942c4a51ea19047b2";
      sha256 = "sha256-OdZuOmxDYvvsCnu9TcogCeB0agCq8o20/YPCmUSwYPw=";
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
      python-lsp-server
      pyyaml
      rope
      wheel
      yapf
    ]);
  in with pkgs; [
    awscli
    cachix
    freerdp
    gdb
    gimp
    gnome.nautilus
    gnuplot
    google-chrome
    git-crypt
    gnumake
    graham33-scripts
    imagemagick
    inkscape
    killall
    libreoffice
    lxterminal
    mpv
    myPython3
    nix-output-monitor
    nix-prefetch-git
    nixpkgs-review
    nixVersions.nix_2_10
    nmap
    pavucontrol
    poppler_utils
    pstree
    remmina
    ripgrep
    rubber
    socat
    sxiv
    texlab
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

  xsession.windowManager.i3 = let
    modifier = config.xsession.windowManager.i3.config.modifier;
    terminal = config.xsession.windowManager.i3.config.terminal;
  in {
    enable = true;
    config = {
      assigns = {
        "1: tmux" = [{ class = "kitty"; title = "tmux"; }];
        "2: web" = [{class = "Google-chrome"; }];
      };
      bars = [{
        statusCommand = "${pkgs.i3status}/bin/i3status";
        fonts = {
          names = [ "Source Code Pro" ];
          size = 11.0;
        };
      }];
      fonts = {
        names = [ "Source Code Pro" ];
        size = 11.0;
      };
      keybindings = let
        refresh_i3status = "killall -SIGUSR1 i3status";
      in lib.mkOptionDefault {
        # movement
        "${modifier}+Shift+j" = "move left";
        "${modifier}+Shift+k" = "move down";
        "${modifier}+Shift+l" = "move up";
        "${modifier}+Shift+semicolon" = "move right";
        # lock screen
        "${modifier}+Shift+s" = "exec --no-startup-id i3lock";
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
        { command = "xset dpms 1800 1800 3600"; }
        # Start terminal with tmux
        { command = "${terminal} --title tmux tmux"; }
        # Start google-chrome
        { command = "google-chrome-stable"; }
      ];
      terminal = "kitty";
    };
    extraConfig = ''
      set $Locker i3lock && sleep 1

      set $mode_system System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown
      mode "$mode_system" {
          bindsym l exec --no-startup-id $Locker, mode "default"
          bindsym e exec --no-startup-id i3-msg exit, mode "default"
          bindsym s exec --no-startup-id $Locker && systemctl suspend, mode "default"
          bindsym h exec --no-startup-id $Locker && systemctl hibernate, mode "default"
          bindsym r exec --no-startup-id systemctl reboot, mode "default"
          bindsym Shift+s exec --no-startup-id systemctl poweroff -i, mode "default"

          # back to normal: Enter or Escape
          bindsym Return mode "default"
          bindsym Escape mode "default"
      }

      bindsym ${modifier}+Shift+Home mode "$mode_system"

      # switch to workspace 1
      exec --no-startup-id i3-msg workspace "1: tmux"
    '';
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
