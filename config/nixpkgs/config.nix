{pkgs}:
let
  myCustomWhitelist = with pkgs.stdenv.lib.licenses; [ artistic1 bsd3 gpl2 gpl3 gpl2Plus gpl3Plus lgpl21 lgpl2Plus lgpl21Plus zlib ];
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
      ]);
    };
  };

}
