{
  allowUnfree = true;

  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        bat
        emacs
        lxterminal
        ripgrep
        tmux
      ];
    };
  };
}
