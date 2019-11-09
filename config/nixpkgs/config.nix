{pkgs}:
let
  myPython = [(pkgs.python3.withPackages (ps: with ps; [
    boto3
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
        emacs
        freerdp
        google-chrome
        lxterminal
        nodejs
        ripgrep
        tmux
      ] ++ (with nodePackages; [
        create-react-app
        serverless
      ]) ++ myPython;
    };
  };

}
