let
  minimalInstall = builtins.getEnv "NIXPKGS_MINIMAL_INSTALL" != "";
in
self: super: {

  graham33-scripts = super.stdenv.mkDerivation {
    name = "graham33-scripts";
    src = super.fetchgit {
      url = "https://github.com/graham33/scripts";
      rev = "2ed8512bdee8cd1fb008cc8bbf49970388466032";
      sha256 = "0j12anmnx4aj79jd08yqq0xkfpfkx8n5b41s3ylbygf2fdxfj3x4";
    };
    buildCommand = ''
      mkdir -p $out/bin
      cp $src/* $out/bin
    '';
  };

  my-packages = let
    #myMpv = super.mpv.override { cddaSupport = true; };

    myPython2 = [(self.python2.withPackages (ps: with ps; [
      arrow
      boto
      units
    ]))];

    myPython3 = [(self.python3.withPackages (ps: with ps; [
      arrow
      boto3
      click
      ciso8601
      dbus-python
      fiblary3
      numpy
      pandas
      pip
      pytest
      python-rtmidi
      python-slugify
      pyyaml
      wheel
      xlib
      yapf
    ]))];

    myTexlive = (super.texlive.combine {
      inherit (super.texlive) crossword lastpage newlfm nopageno
        patchcmd scheme-small titling;
    });

  in
    super.buildEnv {
      name = "my-packages";
      paths = with super; [
        atftp
        awscli
        bat
        bfg-repo-cleaner
        dnsutils
        emacs
        exiftool
        freerdp
        git-crypt
        gnupg
        gnumake
        gopro
        gpsbabel
        imagemagick
        jmtpfs
        libreoffice
        libxml2
        lxterminal
        #myMpv
        mpv
        self.graham33-scripts
        nix
        nixpkgs-review
        nmap
        nodejs
        pavucontrol
        #self.pypi2nix
        remmina
        ripgrep
        terraform
        tio
        tmux
        traceroute
        unzip
        websocat
        wget
        whois
        xorg.xev
        xorg.xmodmap
        xss-lock
      ] ++ (with nodePackages; [
        create-react-app
        serverless
        "socket.io-client"
      ]) ++ myPython2 ++ myPython3
      ++ super.stdenv.lib.optionals (!minimalInstall) [
        audacity
        audio-recorder
        gimp
        gnome3.nautilus
        gnuplot
        google-chrome
        myTexlive
        octaveFull
        skypeforlinux
        vlc
        wine
        self.zoom-us
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
      inherit (self.nur.repos.graham33) fiblary3;
    };
  };

  python38Packages = self.python38.pkgs;

  zoom-us = super.libsForQt5.callPackage ../packages/zoom-us.nix {};
}
