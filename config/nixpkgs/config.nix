{pkgs}:
{
  allowUnfree = true;

  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  permittedInsecurePackages = [
    "xpdf-4.02"
  ];

}
