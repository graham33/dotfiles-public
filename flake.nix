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
      pkgs = import nixpkgs {
        config = {
          allowUnfree = true;
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
            inherit (pkgs-dropbox-patch) dropbox;
          })
        ];
        inherit system;
      };
      mkHomeManagerConfiguration = cudaSupport: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          ./user-config.nix
        ];
        extraSpecialArgs = {
          inherit cudaSupport;
        };
      };
    in {
      homeConfigurations = {
        graham = mkHomeManagerConfiguration true;
        graham-no-cuda = mkHomeManagerConfiguration false;
      };
    };
}
