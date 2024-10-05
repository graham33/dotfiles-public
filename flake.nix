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
  };

  outputs = { nixpkgs, home-manager, emacs-overlay, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        config = {
          allowUnfree = true;
        };
        overlays = [
          emacs-overlay.overlay
        ];
        inherit system;
      };
      mkHomeManagerConfiguration = bloat: cudaSupport: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          ./user-config.nix
        ] ++ pkgs.lib.optionals bloat [
          ./bloat.nix
        ];
        extraSpecialArgs = {
          inherit cudaSupport;
        };
      };
    in {
      homeConfigurations = {
        graham = mkHomeManagerConfiguration true true;
        graham-no-bloat = mkHomeManagerConfiguration true false;
        graham-no-cuda = mkHomeManagerConfiguration true false;
      };
    };
}
