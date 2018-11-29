{ pkgs
, pythonPackages
, uarray
 }:

let pythonEnv = pythonPackages.python.withPackages
                  (ps: with ps; [ uarray ]);
in {

 shell = pkgs.mkShell {
   buildInputs = [ pythonEnv ];
 };

 # nix is THE way to build docker images
 # https://grahamc.com/blog/nix-and-layered-docker-images
 docker = pkgs.dockerTools.buildLayeredImage {
   name = "uarray";
   tag = "latest";
   config.Cmd = [ "${pythonEnv.interpreter}" ];
   maxLayers = 120;
 };

}
