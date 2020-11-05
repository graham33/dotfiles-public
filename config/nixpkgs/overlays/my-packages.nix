let
  minimalInstall = builtins.getEnv "NIXPKGS_MINIMAL_INSTALL" != "";
in
self: super: {

  graham33-scripts = super.stdenv.mkDerivation {
    name = "graham33-scripts";
    src = super.fetchgit {
      url = "https://github.com/graham33/scripts";
      rev = "c07c2288ab18c67c7190feedeaf5a18842e96c28";
      sha256 = "1djs0m13i51i9bibq7gsnr9gd407f5zhd7bm770yvp9vjj68r5n0";
    };
    buildCommand = ''
      mkdir -p $out/bin
      cp $src/* $out/bin
    '';
  };

  my-packages = let
    myMpv = super.mpv.override { cddaSupport = true; };

    myPython2 = [(self.python2.withPackages (ps: with ps; [
      arrow
      boto
      units
    ]))];

    myPython3 = [(self.python3.withPackages (ps: with ps; [
      arrow
      boto3
      click
      dbus-python
      fiblary3
      numpy
      pandas
      pip
      pytest
      python-rtmidi
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
        myMpv
        self.graham33-scripts
        nix
        nixpkgs-review
        nmap
        nodejs
        pavucontrol
        self.pypi2nix
        remmina
        ripgrep
        terraform
        tio
        tmux
        traceroute
        unzip
        whois
        xorg.xev
        xorg.xmodmap
        xss-lock
      ] ++ (with nodePackages; [
        create-react-app
        serverless
      ]) ++ myPython2 ++ myPython3
      ++ super.stdenv.lib.optionals (!minimalInstall) [
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

  pypi2nix = import (super.fetchgit {
    url = "https://github.com/nix-community/pypi2nix";
    # adjust rev and sha256 to desired version
    rev = "v2.0.0";
    sha256 = "sha256:1mrvbm78jnk7m44gvpa7l2iwrjiv9584f14vlcw9p334zxknpsfr";
  }) {};

  python3 = super.python3.override {
    packageOverrides = python-self: python-super: {
      fiblary3 = python-super.callPackage ../packages/fiblary3 {};
      python-rtmidi = python-super.callPackage ../packages/python-rtmidi.nix {};
    };
  };

  python3Packages = self.python3.pkgs;

  zoom-us = super.libsForQt5.callPackage ../packages/zoom-us.nix {};
}
