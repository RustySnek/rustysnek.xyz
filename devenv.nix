{ pkgs, lib, config, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {system = pkgs.stdenv.system; };
in 
{
  packages = [
    unstable.elixir_1_17 unstable.elixir-ls unstable.erlang 
    pkgs.nodePackages_latest.typescript-language-server
    pkgs.vscode-langservers-extracted
    pkgs.tailwindcss-language-server
  ] ++ lib.optionals pkgs.stdenv.isLinux (with pkgs; [inotify-tools]);
}
