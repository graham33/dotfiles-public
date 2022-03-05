{pkgs}:
{
  allowUnfree = true;

  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  permittedInsecurePackages = [
    "adobe-reader-9.5.5"
    "xpdf-4.02"
  ];

}
