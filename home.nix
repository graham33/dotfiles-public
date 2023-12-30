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

  programs.autorandr = {
    enable = true;
    profiles.mobile = {
      config = {
        # Laptop screen
        "eDP-1" = {
          enable = true;
          crtc = 1;
          mode = "2560x1440";
          position = "0x0";
          primary = true;
          rate = "60.00";
        };
      };
      fingerprint = {
        "eDP-1" = "00ffffffffffff0030ae40410000000031190104a51f1278ea4481af503eb5230e5054000000010101010101010101010101010101019b5e00a0a0a02c503020360036af1000001a9b5e00a0a0a02c503020360036af1000001a0000000f00ff093cff093c1e80004c830000000000fe0041544e4134304a5530312d302000a9";
      };
    };
    profiles.docked = {
      config = {
        # Laptop screen
        "eDP-1" = {
          enable = false;
        };
        # Left portrait monitor
        "DP-1" = {
          enable = true;
          crtc = 1;
          mode = "2560x1440";
          position = "0x0";
          rate = "59.95";
          rotate = "left";
        };
        # Main monitor
        "DP-2-1" = {
          enable = true;
          crtc = 0;
          mode = "3840x2160";
          position = "1440x0";
          primary = true;
          rate = "30.00";
        };
      };
      fingerprint = {
        "eDP-1" = "00ffffffffffff0030ae40410000000031190104a51f1278ea4481af503eb5230e5054000000010101010101010101010101010101019b5e00a0a0a02c503020360036af1000001a9b5e00a0a0a02c503020360036af1000001a0000000f00ff093cff093c1e80004c830000000000fe0041544e4134304a5530312d302000a9";
        "DP-1" = "00ffffffffffff0010ac50a14c474930191e0104a5371f783e5095af4f45a9260f5054a54b00714f8180a9c0a940d1c0e100d1000101565e00a0a0a029503020350029372100001a000000ff004a5853533832330a2020202020000000fc0044454c4c205532353230440a20000000fd00304b0a7828010a20202020202001fc02031df150101f200514041312110302161507060123091f0783010000023a801871382d40582c450029372100001ebf1600a08038134030203a0029372100001a7e3900a080381f4030203a0029372100001a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000005d";
        "DP-2-1" = "00ffffffffffff0010acd6414c3639340b1f0103805e3578ea8b5ba4554e9e270e474aa54b00d100d1c0b300a94081808100714fe1c0b8ce0050f0705a8018108a00ad113200001e000000ff004a4d43575138330a2020202020000000fc0044454c4c205534333230510a20000000fd001d4c1e8c3c000a20202020202001ec02033af15161605f5e5d101f2005140413121103020123091f07830100006d030c001000183c20006001020367d85dc401788001e20f03e2006b08e80030f2705a80b0588a00ad113200001e565e00a0a0a0295030203500ad113200001a114400a080001f5030203600ad113200001a00000000000000000000000000000019";
      };
    };
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
          rev = "v0.7.0";
          sha256 = "sha256-oQpYKBt0gmOSBgay2HgbXiDoZo5FoUKwyHSlUrOAP5E=";
        };
      }
    ];
  };

  services.dropbox = {
    enable = true;
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
      rev = "b86a074437503677d21e2172bd175b37edbdb029";
      sha256 = "sha256-FmUqdc9t5Niri0LuK4/ZONFj6aKJMjp8XPqHVWPe8jw=";
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
    ffmpeg-full
    font-awesome
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
    nix
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
    x2goclient
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

  # Let home-manager automatically start systemd user services.
  # Will eventually become the new default.
  systemd.user.startServices = "sd-switch";

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
    };
    xwayland.enable = true;

    extraConfig = builtins.readFile ./hyprland.conf;
  };
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 30;
        modules-left = [ "hyprland/workspaces" ];
        modules-middle = [ "hyprland/window" ];
        modules-right = [ "temperature" "battery" "clock" ];
      };
    };
  };
  programs.wofi.enable = true;

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
      workspaceOutputAssign = [
        { workspace = "1: tmux"; output = "primary"; }
        { workspace = "2: web"; output = "nonprimary"; }
      ];
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
        # Cycle autorandr through detected configurations
        XF86Display = "exec --no-startup-id autorandr --cycle";
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
