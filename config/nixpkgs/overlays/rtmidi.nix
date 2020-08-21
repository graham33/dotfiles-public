self: super: {
  python38 = super.python38.override {
     packageOverrides = python_self: python_super: {

       python-rtmidi = super.pkgs.callPackage ~/.config/nixpkgs/packages/python-rtmidi.nix { inherit (python_super) buildPythonPackage fetchPypi isPy27 tox flake8 alabaster;  };

     };
  };

  python38Packages = self.python38.pkgs;
}
