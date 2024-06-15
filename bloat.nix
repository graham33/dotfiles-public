{ config, lib, pkgs, cudaSupport, ... }:

{
  home.packages = with pkgs; [
    clang
    ffmpeg-full
    font-awesome
    gimp
    gnome.nautilus
    google-chrome
    hypridle
    hyprlock
    inkscape
    libreoffice
    mpv
    nodejs_22
    (ollama.override (lib.optionalAttrs cudaSupport {
      acceleration = "cuda";
    }))
    pavucontrol
    poppler_utils
    remmina
    rubber
    sxiv
    texlab
    vlc
    wally-cli
    x2goclient
    zoom-us
  ];

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

  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      inherit (tpkgs) catchfile crossword lastpage newlfm patchcmd scheme-small svg titling transparent trimspaces;
    };
  };

  xdg.configFile."vlc/vlcrc".source = ./config/vlc/vlcrc;
  xdg.configFile."zoomus.conf".source = ./config/zoomus.conf;
}
