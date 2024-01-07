{
  description = "Home Manager configuration of Graham Bennett";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-dropbox-patch = {
      url = "github:nixos/nixpkgs/refs/pull/277422/merge";
    };
  };

  outputs = { nixpkgs, home-manager, emacs-overlay, nixpkgs-dropbox-patch, ... }:
    let
      system = "x86_64-linux";
    in {
      homeConfigurations.graham = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "openssl-1.1.1v"
            ];
          };
          overlays = let
            pkgs-dropbox-patch = import nixpkgs-dropbox-patch {
              config = {
                allowUnfree = true;
              };
              inherit system;
            };
          in [
            emacs-overlay.overlay
            (self: super: {
              freerdp = super.freerdp.override {
                #openssl = self.openssl_1_1;
              };
              inherit (pkgs-dropbox-patch) dropbox;
            })
          ];
          inherit system;
        };

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
        ];


        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
