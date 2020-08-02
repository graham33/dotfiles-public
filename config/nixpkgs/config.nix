{pkgs, minimalInstall ? (builtins.getEnv "NIXPKGS_MINIMAL_INSTALL" != "")}:
let
  myMpv = pkgs.mpv.override { cddaSupport = true; };

  myPython2 = [(pkgs.python2.withPackages (ps: with ps; [
    arrow
    boto
    units
  ]))];

  python-rtmidi = pkgs.callPackage packages/python-rtmidi.nix { inherit (pkgs.python3Packages) alabaster buildPythonPackage fetchPypi flake8 tox; isPy27 = false; };

  myPython3 = [(pkgs.python3.withPackages (ps: with ps; [
    arrow
    boto3
    click
    dbus-python
    numpy
    pandas
    pip
    pytest
    python-rtmidi
    xlib
    yapf
  ]))];

  myTexlive = (pkgs.texlive.combine {
    inherit (pkgs.texlive) crossword lastpage newlfm nopageno
      patchcmd scheme-small titling;
  });

  myScripts = pkgs.stdenv.mkDerivation {
    name = "graham33-scripts";
    src = pkgs.fetchgit {
      url = "https://github.com/graham33/scripts";
      rev = "f1d6a02f712c331cc8907c51d36b9f6896ddfe21";
      sha256 = "130qy72428xib0pmw48a0h63sa6in6k99acp1gj15kv8xqlh351c";
    };
    buildCommand = ''
      mkdir -p $out/bin
      cp $src/* $out/bin
    '';
  };

  pypi2nix = import (pkgs.fetchgit {
    url = "https://github.com/nix-community/pypi2nix";
    # adjust rev and sha256 to desired version
    rev = "v2.0.0";
    sha256 = "sha256:1mrvbm78jnk7m44gvpa7l2iwrjiv9584f14vlcw9p334zxknpsfr";
  }) {};
in
{
  allowUnfree = true;

  #licenseCheckPredicate = attrs: attrs ? name && attrs.name == "pcre-8.43";

  # blacklistedLicenses = with pkgs.stdenv.lib.licenses; [ agpl3Plus ];

  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        atftp
        awscli
        bat
        dnsutils
        emacs
        exiftool
        freerdp
        gimp
        gnome3.nautilus
        gnumake
        google-chrome
        gopro
        gpsbabel
        imagemagick
        jmtpfs
        libreoffice
        lxterminal
        myMpv
        myScripts
        nix
        nmap
        nodejs
        pypi2nix
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
        zoom-us
      ] ++ (with nodePackages; [
        create-react-app
        serverless
      ]) ++ myPython2 ++ myPython3
        ++ pkgs.stdenv.lib.optionals (!minimalInstall) [myTexlive];
    };
  };

}
