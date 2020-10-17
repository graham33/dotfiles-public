let
  minimalInstall = builtins.getEnv "NIXPKGS_MINIMAL_INSTALL" != "";
in
self: super: {

  graham33-scripts = super.stdenv.mkDerivation {
    name = "graham33-scripts";
    src = super.fetchgit {
      url = "https://github.com/graham33/scripts";
      rev = "f1d6a02f712c331cc8907c51d36b9f6896ddfe21";
      sha256 = "130qy72428xib0pmw48a0h63sa6in6k99acp1gj15kv8xqlh351c";
    };
    buildCommand = ''
      mkdir -p $out/bin
      cp $src/* $out/bin
    '';
  };

  my-packages = let
    myMpv = super.mpv.override { cddaSupport = true; };

    myPython2 = [(self.python2.withPackages (ps: with ps; [
      arrow
      boto
      units
    ]))];

    myPython3 = [(self.python3.withPackages (ps: with ps; [
      arrow
      boto3
      click
      dbus-python
      numpy
      pandas
      pip
      pytest
      python-rtmidi
      xlib
      yapf
    ]))];

    myTexlive = (super.texlive.combine {
      inherit (super.texlive) crossword lastpage newlfm nopageno
        patchcmd scheme-small titling;
    });

  in
    super.buildEnv {
      name = "my-packages";
      paths = with super; [
        atftp
        awscli
        bat
        bfg-repo-cleaner
        dnsutils
        emacs
        exiftool
        freerdp
        git-crypt
        gnupg
        gnumake
        gopro
        gpsbabel
        imagemagick
        jmtpfs
        libreoffice
        libxml2
        lxterminal
        myMpv
        self.graham33-scripts
        nix
        nixpkgs-review
        nmap
        nodejs
        pavucontrol
        self.pypi2nix
        remmina
        ripgrep
        terraform
        tio
        tmux
        traceroute
        unzip
        whois
        xorg.xev
        xorg.xmodmap
        xss-lock
      ] ++ (with nodePackages; [
        create-react-app
        serverless
      ]) ++ myPython2 ++ myPython3
      ++ super.stdenv.lib.optionals (!minimalInstall) [
        gimp
        gnome3.nautilus
        gnuplot
        google-chrome
        myTexlive
        octaveFull
        skypeforlinux
        vlc
        self.zoom-us
      ];
    };

  pypi2nix = import (super.fetchgit {
    url = "https://github.com/nix-community/pypi2nix";
    # adjust rev and sha256 to desired version
    rev = "v2.0.0";
    sha256 = "sha256:1mrvbm78jnk7m44gvpa7l2iwrjiv9584f14vlcw9p334zxknpsfr";
  }) {};

  python3 = super.python3.override {
    packageOverrides = python-self: python-super: {
      python-rtmidi = python-super.callPackage ../packages/python-rtmidi.nix {};
    };
  };

  python3Packages = self.python3.pkgs;

  zoom-us = let
    # Used for icons, appdata, and desktop file.
    desktopIntegration = self.fetchFromGitHub {
      owner = "flathub";
      repo = "us.zoom.Zoom";
      rev = "0d294e1fdd2a4ef4e05d414bc680511f24d835d7";
      sha256 = "0rm188844a10v8d6zgl2pnwsliwknawj09b02iabrvjw5w1lp6wl";
    };
    in
      super.zoom-us.overrideAttrs(o: rec {
        version = "5.3.465578.0920";
        src = self.fetchurl {
          url = "https://zoom.us/client/${version}/zoom_x86_64.tar.xz";
          sha256 = "0gqpisbzyx2xic0drvyqfbd2x2a5qcizl355qkwwibq3v24mx7kp";
        };

        installPhase =
          let
            files = self.lib.concatStringsSep " " [
              "*.pcm"
              "*.png"
              "ZoomLauncher"
              "config-dump.sh"
              "timezones"
              "translations"
              "version.txt"
              "zcacert.pem"
              "zoom"
              "zoom.sh"
              "zopen"
            ];
          in ''
            runHook preInstall
            mkdir -p $out/{bin,share/zoom-us}
            cp -ar ${files} $out/share/zoom-us
            # TODO Patch this somehow; tries to dlopen './libturbojpeg.so' from cwd
            cp libturbojpeg.so $out/share/zoom-us/libturbojpeg.so
            # Again, requires faac with a nonstandard filename.
            ln -s $(readlink -e "${self.faac}/lib/libfaac.so") $out/share/zoom-us/libfaac1.so
            runHook postInstall
          '';

        postInstall = ''
          mkdir -p $out/share/{applications,appdata,icons}
          # Desktop File
          cp ${desktopIntegration}/us.zoom.Zoom.desktop $out/share/applications
          substituteInPlace $out/share/applications/us.zoom.Zoom.desktop \
            --replace "Exec=zoom" "Exec=$out/bin/zoom-us"
          # Appdata
          cp ${desktopIntegration}/us.zoom.Zoom.appdata.xml $out/share/appdata
          # Icons
          for icon_size in 64 96 128 256; do
              path=$icon_size'x'$icon_size
              icon=${desktopIntegration}/us.zoom.Zoom.$icon_size.png
              mkdir -p $out/share/icons/hicolor/$path/apps
              cp $icon $out/share/icons/hicolor/$path/apps/us.zoom.Zoom.png
          done
        '';
      });
}
