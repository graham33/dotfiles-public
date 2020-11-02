self: super: {
  python37 = super.python37.override {
     packageOverrides = python_self: python_super: {

       fiblary3 = super.pkgs.callPackage ~/.config/nixpkgs/packages/fiblary3 { inherit (python_super) buildPythonPackage fetchPypi jsonpatch netaddr prettytable python-dateutil requests six sphinx;  };

     };
  };

  python37Packages = self.python37.pkgs;
}
