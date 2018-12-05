{ pkgs
, pythonPackages
, matchpy
}:

let pythonEnv = pythonPackages.python.withPackages
                  (ps: with ps; [ matchpy jupyterlab graphviz ]);
in {

 shell = pkgs.mkShell {
   buildInputs = [ pythonEnv pkgs.graphviz ];
 };
}
