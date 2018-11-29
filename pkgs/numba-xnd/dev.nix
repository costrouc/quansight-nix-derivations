{ pkgs
, pythonPackages
, numba-xnd
 }:

let pythonEnv = pythonPackages.python.withPackages
                  (ps: with ps; [ numba-xnd ]);
in {

 shell = pkgs.mkShell {
   buildInputs = [ pythonEnv ];
 };

 docker = pkgs.dockerTools.buildLayeredImage {
   name = "numba-xnd";
   tag = "latest";
   config.Cmd = [ "${pythonEnv.interpreter}" ];
   maxLayers = 120;
 };

}
