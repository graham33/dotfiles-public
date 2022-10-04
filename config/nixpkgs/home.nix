{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "graham";
  home.homeDirectory = "/home/graham";

  programs.bat.enable = true;
  programs.git = {
    enable = true;
    userName = "Graham Bennett";
    userEmail = "graham@grahambennett.org";
    extraConfig = {
      pull = { rebase = "true"; };
      push = { default = "simple"; };
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
    };
    aliases = {
      co = "pr checkout";
      pv = "pr view";
    };
  };
  programs.htop.enable = true;
  programs.jq.enable = true;

  home.file.".emacs.d" = {
    # don't make the directory read only so that impure melpa can still happen
    # for now
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "syl20bnr";
      repo = "spacemacs";
      rev = "4688cd7dcea36ee346d1aafba7f0638f4d816c28";
      sha256 = "sha256-M5xr4pRpiKbyg68oADrCHGLdiB3cFnzkmh9WHFTI/Mw=";
    };
  };

  home.packages = with pkgs; [
    gdb
    gnumake
    ripgrep
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
