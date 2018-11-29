{ pkgs
, pythonPackages
, gumath
 }:

# nix is THE way to build docker images
# https://grahamc.com/blog/nix-and-layered-docker-images
let python = pythonPackages.python.withPackages (ps: with ps; [ gumath ]);
in
pkgs.dockerTools.buildLayeredImage {
  name = "gumath";
  tag = "latest";
  config.Cmd = [ "${python.interpreter}" ];
  maxLayers = 120;
}
