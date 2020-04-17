{pkgs}:
let
  myPython2 = [(pkgs.python2.withPackages (ps: with ps; [
    boto
  ]))];
  myPython3 = [(pkgs.python3.withPackages (ps: with ps; [
    boto3
    dbus-python
    numpy
    pandas
  ]))];
  myTexlive = (pkgs.texlive.combine {
    inherit (pkgs.texlive) crossword lastpage newlfm patchcmd scheme-small titling;
  });
in
{
  allowUnfree = true;

  #licenseCheckPredicate = attrs: attrs ? name && attrs.name == "pcre-8.43";

  # blacklistedLicenses = with pkgs.stdenv.lib.licenses; [ agpl3Plus ];

  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
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
        mpv
        myTexlive
        nmap
        nodejs
        remmina
        ripgrep
        tmux
        unzip
        whois
      ] ++ (with nodePackages; [
        create-react-app
        serverless
      ]) ++ myPython2 ++ myPython3;
    };
  };

}
