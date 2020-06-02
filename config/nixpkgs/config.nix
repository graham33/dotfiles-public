{pkgs}:
let
  myMpv = pkgs.mpv.override { cddaSupport = true; };

  myPython2 = [(pkgs.python2.withPackages (ps: with ps; [
    arrow
    boto
    units
  ]))];

  myPython3 = [(pkgs.python3.withPackages (ps: with ps; [
    arrow
    boto3
    dbus-python
    numpy
    pandas
    xlib
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
        myTexlive
        nmap
        nodejs
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
      ]) ++ myPython2 ++ myPython3;
    };
  };

}
