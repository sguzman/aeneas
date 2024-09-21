{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    espeak
  ];

  # Optionally set any environment variables or shell hooks.
  shellHook = ''
    echo "Welcome to your Nix shell environment!"
  '';
}

