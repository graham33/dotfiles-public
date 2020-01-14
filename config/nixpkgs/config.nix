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
        google-chrome
        imagemagick
        lxterminal
        nodejs
	remmina
        ripgrep
        tmux
        unzip
      ] ++ (with nodePackages; [
        create-react-app
        serverless
      ]) ++ myPython2 ++ myPython3;
    };
  };

}