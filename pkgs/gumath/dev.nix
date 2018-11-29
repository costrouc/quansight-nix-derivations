{ pkgs
, pythonPackages
, gumath
 }:

let pythonEnv = pythonPackages.python.withPackages
                  (ps: with ps; [ gumath ]);
in {

 shell = pkgs.mkShell {
   buildInputs = [ pythonEnv ];
 };

 # nix is THE way to build docker images
 # https://grahamc.com/blog/nix-and-layered-docker-images
 docker = pkgs.dockerTools.buildLayeredImage {
   name = "gumath";
   tag = "latest";
   config.Cmd = [ "${pythonEnv.interpreter}" ];
   maxLayers = 120;
 };

}
