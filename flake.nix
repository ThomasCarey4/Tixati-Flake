{
  inputs = {
    # Use the latest nixpkgs for upstream support
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        # Allow unfree binaries like Tixati
        config = {
          allowUnfree = true;
        }; # :contentReference[oaicite:0]{index=0}
      };
    in
    {
      # Expose as a package in this flake
      packages.${system}.tixati = pkgs.stdenv.mkDerivation rec {
        pname = "tixati";
        version = "3.34-1";

        # Fetch the manual-install tarball
        src = pkgs.fetchurl {
          url = "https://download.tixati.com/tixati-${version}.x86_64.manualinstall.tar.gz";
          sha256 = "e2KCRqNSfkmwBygc7rFlio2o4fI+59y03FPnrVwognI="; # run `nix-prefetch-url <URL>` to get this :contentReference[oaicite:1]{index=1}
        };
        buildInputs = [
          pkgs.dbus # D-Bus IPC core :contentReference[oaicite:11]{index=11}
          pkgs.dbus-glib # D-Bus GLib bindings :contentReference[oaicite:12]{index=12}
          pkgs.glib # Core GNOME libraries :contentReference[oaicite:13]{index=13}
          pkgs.gtk3 # GTK3 GUI toolkit :contentReference[oaicite:14]{index=14}
          pkgs.pango # Text layout/rendering :contentReference[oaicite:15]{index=15}
          pkgs.cairo # 2D graphics library :contentReference[oaicite:16]{index=16}
          # pkgs.gdk_pixbuf # Image loading/manipulation :contentReference[oaicite:17]{index=17}
          pkgs.zlib # Compression support :contentReference[oaicite:18]{index=18}
        ];

        nativeBuildInputs = [
          pkgs.makeWrapper
          pkgs.autoPatchelfHook
        ];

        # Unpack and install everything into $out
        unpackPhase = "gzip -dc $src | tar xvf -";
        installPhase = ''
          mkdir -p $out/bin $out/lib
          cp -r tixati-${version}.x86_64.manualinstall/* $out/
          cp $out/tixati $out/bin/

          # Wrap the launcher so it picks up its bundled .so files  
          wrapProgram $out/bin/tixati \
            --prefix LD_LIBRARY_PATH ":${pkgs.glib}/${pkgs.cairo}/${pkgs.dbus}/lib:$out/lib"
        '';

        meta = with pkgs.lib; {
          description = "Tixati BitTorrent client (wrapped standalone binary)";
          license = licenses.unfree;
          platforms = [ "x86_64-linux" ];
        };
      };

      # Make `nix run .#tixati` or `nix profile install .#tixati` work by default
      defaultPackage.${system} = self.packages.${system}.tixati;
      devShell.${system} = pkgs.mkShell {
        buildInputs = [ self.packages.${system}.tixati ];
      };
    };
}
