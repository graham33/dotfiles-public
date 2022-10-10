let
  minimalInstall = builtins.getEnv "NIXPKGS_MINIMAL_INSTALL" != "";
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
self: super: {

  graham33-scripts = super.stdenv.mkDerivation {
    name = "graham33-scripts";
    src = super.fetchgit {
      url = "https://github.com/graham33/scripts";
      rev = "8808769ce17fe747d80f73d802dd3ade147a38b8";
      sha256 = "099nsij8s4cawlid08v8mg5iqyb9ikdg546cdm4d8p1g1d9y8jja";
    };
    buildCommand = ''
      mkdir -p $out/bin
      cp $src/* $out/bin
    '';
  };

  my-packages = let
    #myMpv = super.mpv.override { cddaSupport = true; };

    # myPython3 = [(self.python3.withPackages (ps: with ps; [
    #   arrow
    #   boto3
    #   click
    #   ciso8601
    #   dbus-python
    #   numpy
    #   pandas
    #   pip
    #   pytest
    #   python-rtmidi
    #   python-slugify
    #   pyyaml
    #   wheel
    #   xlib
    #   yapf
    # ]))];

    # myTexlive = (super.texlive.combine {
    #   inherit (super.texlive) crossword lastpage newlfm nopageno
    #     patchcmd scheme-small titling;
    # });

  in
    super.buildEnv {
      name = "my-packages";
      paths = with super; [
        appimage-run
        atftp
        #awscli
        #bat
        bfg-repo-cleaner
        #cachix
        #direnv
        dnsutils
        exiftool
        freerdp
        #gdb
        #gh
        #git-crypt
        #gnupg
        #gnumake
        gpsbabel
        #htop
        imagemagick
        jmtpfs
        #jq
        lego
        #libreoffice
        libxml2
        losslesscut-bin
        #lxterminal
        #self.graham33-scripts
        #nix-direnv
        #nix-prefetch-git
        #nixpkgs-review
        #nmap
        nodejs
        #pavucontrol
        #pstree
        #self.pypi2nix
        #remmina
        #ripgrep
        scrcpy
        semver-tool
        #socat
        terraform
        tio
        #tmux
        #traceroute
        #unzip
        #wally-cli
        #websocat
        #wget
        #whois
        xorg.xev
        xorg.xmodmap
        #xss-lock
      ] ++ (with nodePackages; [
        create-react-app
        serverless
        "socket.io-client"
      ]) # ++ myPython3
      ++ super.lib.optionals (!minimalInstall) [
        adobe-reader
        apktool
        audacity
        audio-recorder
        evince
        #gimp
        #gnome3.nautilus
        #gnuplot
        #google-chrome
        gopro
        #myMpv
        #mpv
        # myTexlive
        octaveFull
        skypeforlinux
        #sxiv
        v4l-utils
        #vlc
        #vscode
        wine
        #unstable.zoom-us
        xournalpp
        #yarn2nix
      ];
    };

  #pypi2nix = import (super.fetchgit {
  #  url = "https://github.com/nix-community/pypi2nix";
  #  # adjust rev and sha256 to desired version
  #  rev = "v2.0.0";
  #  sha256 = "sha256:1mrvbm78jnk7m44gvpa7l2iwrjiv9584f14vlcw9p334zxknpsfr";
  #}) {};

  python38 = super.python38.override {
    packageOverrides = python-self: python-super: {
    };
  };

  python38Packages = self.python38.pkgs;
}
