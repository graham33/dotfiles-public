{ config, pkgs, lib, cudaSupport, ... }:

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

  fonts.fontconfig.enable = true;

  programs.awscli = {
    enable = true;
    settings = {
      "default" = {
        region = "eu-west-1";
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
    tmux.shellIntegrationOptions = ["-p80%,60%"];
  };
  programs.git = {
    enable = true;
    userName = "Graham Bennett";
    userEmail = "graham@grahambennett.org";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
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
  programs.kitty = {
    enable = true;
    extraConfig = ''
      enable_audio_bell no
    '';
    font = {
      name = "FiraCode Nerd Font Mono Reg";
      size = 14;
    };
    theme = "Solarized Dark";
  };
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

      set -ag terminal-overrides ",xterm-kitty:Tc"
      set-option -ag update-environment "WAYLAND_DISPLAY"

      # Update WAYLAND_DISPLAY on attach
      set-hook -g client-attached 'run-shell update_wayland_display.sh'
    '';
    historyLimit = 100000;
    keyMode = "vi";
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
    initExtra = ''
      # Work around problem with env init clobbering EDITOR
      export EDITOR="emacsclient -nw -c"
      export PATH="$PATH:$HOME/.config/emacs/bin"
      source ~/.op/plugins.sh
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "direnv"
        "git"
        "vi-mode"
      ];
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

  home.packages = let
    graham33-scripts = pkgs.stdenv.mkDerivation {
      name = "graham33-scripts";
      src = pkgs.fetchgit {
        url = "https://github.com/graham33/scripts";
        rev = "6dfe86fe4e82ba759ddf5b3cad7f0375b6d6da09";
        sha256 = "sha256-4iiNxaFznnBO5G56dkHP00e/4JxO8cIu1KHnliZYPjw=";
      };
      buildCommand = ''
      mkdir -p $out/bin
      cp $src/* $out/bin
    ''   ;
    };
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
    clang
    coreutils
    fd
    ffmpeg-full
    font-awesome
    fira-code-nerdfont
    freerdp
    gdb
    gimp
    gnome.nautilus
    gnuplot
    google-chrome
    git-crypt
    gnumake
    graham33-scripts
    hypridle
    hyprlock
    imagemagick
    inkscape
    killall
    libreoffice
    markdownlint-cli2
    mdl
    mpv
    myPython3
    nix
    nix-output-monitor
    nix-prefetch-git
    nixfmt
    nixpkgs-review
    nmap
    nodejs_21
    (ollama.override (lib.optionalAttrs cudaSupport {
      acceleration = "cuda";
    }))
    pavucontrol
    poppler_utils
    pstree
    remmina
    ripgrep
    rubber
    shellcheck
    socat
    sxiv
    texlab
    traceroute
    unzip
    vlc
    wally-cli
    waypipe
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
    systemd.enable = true;
    xwayland.enable = true;

    extraConfig = builtins.readFile ./hyprland.conf;
  };
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-middle = [ ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "disk" "temperature" "battery" "clock" "tray" ];
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        disk = {
          format = "{percentage_free}% ";
        };
        "hyprland/window" = {
          max-length = 200;
          separate-outputs = true;
        };
        "hyprland/workspaces" = {
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        memory = {
          format = "{}% ";
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ipaddr}/{cidr} ";
            tooltip-format = "{ifname} via {gwaddr} ";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            on-click = "pavucontrol";
        };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
        };
      };
    };
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };
  programs.wofi.enable = true;
  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    tray = true;
  };
  services.mako.enable = true;

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
