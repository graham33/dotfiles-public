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
    nix-snapshotter = {
      url = "github:pdtpartners/nix-snapshotter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, emacs-overlay, nix-snapshotter, ... }:
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
          overlays = [
            emacs-overlay.overlay
            (self: super: {
              freerdp = super.freerdp.override {
                openssl = self.openssl_1_1;
              };
            })
          ];
          inherit system;
        };

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          # nix-snapshotter
          ({ pkgs, ... }: {
            # (1) Import home-manager module.
            imports = [ nix-snapshotter.homeModules.nix-snapshotter-rootless ];

            # (2) Add overlay.
            nixpkgs.overlays = [ nix-snapshotter.overlays.default ];

            # (3) Enable service.
            services.nix-snapshotter.rootless = {
              enable = false;
              setContainerdSnapshotter = true;
            };

            # (4) Add a containerd CLI like nerdctl.
            home.packages = [ pkgs.nerdctl ];
          })
        ];


        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
