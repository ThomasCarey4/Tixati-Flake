{
  description = "Tixati - A simple and easy to use BitTorrent client";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # or the appropriate system for your architecture
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
    {
      packages.${system}.tixati = pkgs.stdenv.mkDerivation rec {
        pname = "tixati";
        version = "3.26"; # Update to the correct version if necessary

        src = ./.;

        nativeBuildInputs = [ pkgs.makeWrapper ];

        installPhase = ''
          mkdir -p $out
          mkdir -p $out/share/applications
          mkdir -p $out/share/icons/hicolor/48x48/apps
          cp share/applications/tixati.desktop $out/share/applications
          cp share/icons/hicolor/48x48/apps/tixati.png $out/share/icons/hicolor/48x48/apps
          wget https://download2.tixati.com/download/tixati-3.26-1.x86_64.manualinstall.tar.gz
          tar -xzvf tixati-3.26-1.x86_64.manualinstall.tar.gz
          mv tixati-3.26-1.x86_64.manualinstall/tixati $out/bin
          rm -rf tixati-3.26-1.x86_64.manualinstall
          rm tixati-3.26-1.x86_64.manualinstall.tar.gz
        '';

        meta = with pkgs.lib; {
          description = "Tixati - A simple and easy to use BitTorrent client";
          homepage = "https://www.tixati.com/";
          license = licenses.unfree;
          maintainers = with maintainers; [ "Thomas Carey" ];
          platforms = platforms.linux;
        };
      };

      # Expose the package as a NixOS module
      devShell.${system} = pkgs.mkShell {
        buildInputs = [ self.packages.${system}.tixati ];
      };
    };
}
